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
    @Published var food: Foods?
    static let instance  = FoodViewModel()
    
    func getFoodFromID(id: String, completion: @escaping () -> Void) {
            let foodDocumentRef = db.collection("Calories").document(id)
            foodDocumentRef.getDocument { document, error in
                if let error = error {
                    print("Error fetching document: \(error)")
                    completion()
                } else if let document = document, document.exists {
                    let data = document.data()
                    let amount = data?["amount"] as? String ?? ""
                    let calorie = data?["calorie"] as? Float ?? 0.0
                    let carbohydrate = data?["carbohydrate"] as? Float ?? 0.0
                    let fat = data?["fat"] as? Float ?? 0.0
                    let fiber = data?["fiber"] as? Float ?? 0.0
                    let name = data?["name"] as? String ?? ""
                    let protein = data?["protein"] as? Float ?? 0.0
                    let food = Foods(id: id, amount: amount, calorie: calorie, carbohydrate: carbohydrate, fat: fat, fiber: fiber, name: name, protein: protein)
                    self.food = food
                    completion()
                } else {
                    print("Document does not exist")
                    completion()
                }
            }
        }
    
    func getAllFood(mealType: Int, completion: @escaping () -> Void) {
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
                    let id = document.documentID
                    let amount = data["amount"] as? String ?? ""
                    let calorie = data["calorie"] as? Float ?? 0.0
                    let carbohydrate = data["carbohydrate"] as? Float ?? 0.0
                    let fat = data["fat"] as? Float ?? 0.0
                    let fiber = data["fiber"] as? Float ?? 0.0
                    let name = data["name"] as? String ?? ""
                    let protein = data["protein"] as? Float ?? 0.0
                    return Foods(id: id, amount: amount, calorie: calorie, carbohydrate: carbohydrate, fat: fat, fiber: fiber, name: name, protein: protein)
                }
                
                self.foods = calories
                print("self.foods \(self.foods.count)")
                completion()
        }
    }
    
    func searchFood(searchQuery: String, completion: @escaping (_ foods: [Foods]) -> Void) {
        let foods = foods.filter{ $0.name.contains(searchQuery) }
        if  !foods.isEmpty {
            completion(foods)
        }
    }
    
}
