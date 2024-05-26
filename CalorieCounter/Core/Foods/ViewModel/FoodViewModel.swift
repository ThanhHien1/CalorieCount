//
//  FoodViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import Combine
import FirebaseAuth
import FirebaseFirestoreInternal

class FoodViewModel: ObservableObject {
    let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    var foods: [Foods] = []
    static let instance  = FoodViewModel()
    
    func getAllFood(mealType: Int, completion: @escaping () -> Void) {
        if let currentUser = Auth.auth().currentUser?.email {
            let caloriesCollectionRef = db.collection("Calories")
            listener = caloriesCollectionRef.addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                let calories = documents.compactMap { document in
                    let data = document.data()
                    let amount = data["amount"] as? String ?? ""
                    let calorie = data["calorie"] as? Float ?? 0.0
                    let carbohydrate = data["carbohydrate"] as? Float ?? 0.0
                    let fat = data["fat"] as? Float ?? 0.0
                    let fiber = data["fiber"] as? Float ?? 0.0
                    let name = data["name"] as? String ?? ""
                    let protein = data["protein"] as? Float ?? 0.0
                    return Foods(amount: amount, calorie: calorie, carbohydrate: carbohydrate, fat: carbohydrate, fiber: fiber, name: name, protein: protein)
                }
                self.foods = calories
                completion()
            }
        }
    }
    
    func searchFood(searchQuery: String, completion: @escaping (_ foods: [Foods]) -> Void) {
        let foods = foods.filter{ $0.name.contains(searchQuery) }
        if  !foods.isEmpty {
            completion(foods)
        }
    }
    
}
