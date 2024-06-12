//
//  UserGoals.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation
import SwiftData
import FirebaseAuth
import FirebaseFirestoreInternal

class UserGoals: ObservableObject  {
    
    let db = Firestore.firestore()
    @Published var user: UserData? = nil
    @Published var weightGoal : Double?
    @Published var stepsGoal : Double?
    @Published var dailyCaloriesGoal: Int?
    @Published var dailyFatsGoal: Int?
    @Published var dailyProteinGoal: Int?
    @Published var dailyCarbsGoal: Int?
    @Published var totalBreakfastCal: Int = 0
    @Published var totalLunchCal: Int = 0
    @Published var totalDinnerCal: Int = 0
    @Published var totalSnacksCal: Int = 0
    @Published var foodToday: [FoodToday] = []
    private var listener: ListenerRegistration?
    static let instance = UserGoals()
    let goalViewModel = GoalViewModel.instance
    
    init(_ weightGoal: Double? = nil, _ stepsGoal: Double? = nil) {
        self.weightGoal = weightGoal
        self.stepsGoal = stepsGoal
        fetchUserData() { _ in
        }
    }
    
    func fetchUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        print("2")
        if let currentUserEmail = Auth.auth().currentUser?.email {
            db.collection("User").document(currentUserEmail).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = document, document.exists else {
                    let documentNotFoundError = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                    completion(.failure(documentNotFoundError))
                    return
                }
                
                do {
                    guard let userData = document.data() else {
                        let dataParsingError = NSError(domain: "Firestore", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse document data"])
                        completion(.failure(dataParsingError))
                        return
                    }
                    
                    let userEmail = currentUserEmail
                    let calorie = userData["calorie"] as? Int ?? 0
                    let sex = userData["sex"] as? String ?? ""
                    let weight = userData["weight"] as? Float ?? 0.0
                    let height = userData["height"] as? Float ?? 0.0
                    let age = userData["age"] as? Int ?? 0
                    let activeness = userData["activeness"] as? String ?? ""
                    let bmh = userData["bmh"] as? Float ?? 0
                    let bmi = userData["bmi"] as? Float ?? 0.0
                    let changeCalorieAmount = userData["changeCalorieAmount"] as? Int ?? 0
                    let goalType = userData["goalType"] as? String ?? ""
                    let currentDay = userData["currentDay"] as? String ?? ""
                    let currentCarbs = userData["currentCarbs"]  as? Int ?? 0
                    let currentPro = userData["currentPro"] as? Int ?? 0
                    let currentFat = userData["currentFat"]  as? Int ?? 0
                    let caloriesConsumed = userData["caloriesConsumed"] as? Int ?? 0
                    self.user = UserData(email: userEmail, calorie: calorie, sex: sex, weight: weight, height:height, age: age, activeness: activeness, bmh: bmh, bmi: bmi, changeCalorieAmount: changeCalorieAmount, goalType: goalType, date: currentDay, currentCarbs: currentCarbs, currentPro: currentPro, currentFat: currentFat, caloriesConsumed: caloriesConsumed)
                    print("#########fetch\(self.user)")
                    self.dailyCaloriesGoal = self.user?.calorie ?? 0
                    print("&&&& \(String(describing: self.user?.bmh))")
                    print("dailyCaloriesGoal \(String(describing: self.dailyCaloriesGoal))")
                    self.calculateTotalCalNeeds()
                    completion(.success(self.user!))
                } catch let parsingError {
                    completion(.failure(parsingError))
                }
            }
        }
    }
    
    func fetchFoodToday(completion: @escaping ([FoodToday]?) -> Void) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            completion(nil)
            return
        }
        
        let documentRef = Firestore.firestore().collection("foodToday").document(currentUserEmail)
        
        documentRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist")
                completion(nil)
                return
            }
            
            guard let data = document.data(), let foodDataArray = data["foods"] as? [Any] else {
                print("No food data found in document")
                completion(nil)
                return
            }
            
            var foodArray: [FoodToday] = []
            
            for foodData in foodDataArray {
                if let jsonData = try? JSONSerialization.data(withJSONObject: foodData),
                   let food = try? JSONDecoder().decode(FoodToday.self, from: jsonData) {
                    foodArray.append(food)
                } else {
                    print("Error serializing or decoding food data: \(foodData)")
                }
            }
            self.foodToday = foodArray
            completion(foodArray)
        }
    }
    
    func deleteFood(foodToDelete: FoodToday, completion: @escaping (Bool) -> Void) {
           guard let currentUserEmail = Auth.auth().currentUser?.email else {
               print("No current user logged in")
               completion(false)
               return
           }
           
           let documentRef = Firestore.firestore().collection("foodToday").document(currentUserEmail)
           
           documentRef.getDocument { (document, error) in
               if let document = document, document.exists {
                   if var currentData = document.data(), var existingFoods = currentData["foods"] as? [[String: Any]] {
                       if let index = existingFoods.firstIndex(where: { $0["id"] as? String == foodToDelete.id })  {
                           existingFoods.remove(at: index)
                           documentRef.setData(["foods": existingFoods]) { err in
                               if let err = err {
                                   print("Error updating document: \(err)")
                                   completion(false)
                               } else {
                                   print("Document successfully updated!")
                                   self.foodToday.removeAll { $0.id == foodToDelete.id }
                                   self.user?.caloriesConsumed -= Int(foodToDelete.foods[0].calorie)
                                   self.user?.currentFat -= Int(foodToDelete.foods[0].fat)
                                   self.user?.currentPro -= Int(foodToDelete.foods[0].protein)
                                   self.user?.currentCarbs -= Int(foodToDelete.foods[0].carbohydrate)
                                   if let user = self.user {
                                       self.goalViewModel.updateUserData(user: user, completion: {
                                           completion(true)
                                       })
                                   }
                               }
                           }
                       } else {
                           print("Food item not found")
                           completion(false)
                       }
                   } else {
                       print("Document data was empty or format was unexpected")
                       completion(false)
                   }
               } else {
                   print("Document does not exist")
                   completion(false)
               }
           }
       }

    
    private func calculateTotalCalNeeds() {
        let carbsCalorie = Float(dailyCaloriesGoal ?? 0) * Float(0.5)
        dailyCarbsGoal = Int(carbsCalorie / Float(4.1))
        print("dailyCarbsGoal \(dailyCarbsGoal)")
        let proteinsCalorie = Float(dailyCaloriesGoal ?? 0) * Float(0.3)
        dailyProteinGoal = Int(proteinsCalorie / Float(4.1))
        print("dailyProteinGoal \(dailyProteinGoal)")
        let fatsCalorie = Float(dailyCaloriesGoal ?? 0) * Float(0.2)
        dailyFatsGoal = Int(fatsCalorie / Float(9.2))
        print("dailyFatsGoal \(dailyFatsGoal)")
        // total calorie * 3/10
        totalBreakfastCal = Int(Float(dailyCaloriesGoal ?? Int(0)) * Float(0.3))
        // total calorie * 4/10
        totalLunchCal = Int(Float(dailyCaloriesGoal ?? Int(0)) * Float(0.4))
        // total calorie * 25/100
        totalDinnerCal = Int(Float(dailyCaloriesGoal ?? Int(0)) * Float(0.25))
        // total calorie * 5/100
        totalSnacksCal = Int(Float(dailyCaloriesGoal ?? Int(0)) * Float(0.05))
        
        let totalAdjustedCalories = (totalBreakfastCal) + (totalLunchCal) + (totalDinnerCal) + (totalSnacksCal)
        let adjustment  = (dailyCaloriesGoal ?? 0) - totalAdjustedCalories
        if adjustment != 0 {
            totalBreakfastCal += adjustment
        }
        
    }
    
    
    func updateAll(_ calories : Int?, _ fats: Int?, _ protein: Int?, _ carbs: Int?){
        dailyCaloriesGoal = calories
        dailyFatsGoal = fats
        dailyProteinGoal = protein
        dailyCarbsGoal = carbs
    }
}
