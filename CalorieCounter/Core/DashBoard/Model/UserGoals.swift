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

enum MealType: Int, CaseIterable {
    case breakfast = 0
    case lunch = 1
    case dinner = 2
    case snacks = 3
    
    var value: Int {
        switch self {
        case .breakfast:
            0
        case .lunch:
            1
        case .dinner:
            2
        case .snacks:
            3
        }
    }
    
    var title: String {
        switch self {
        case .breakfast:
            "Breakfast"
        case .lunch:
            "Lunch"
        case .dinner:
            "Dinner"
        case .snacks:
            "Snacks"
        }
    }
    
    
}

class UserGoals: ObservableObject  {
    
    let db = Firestore.firestore()
    @Published var user: UserData? = nil
    @Published var weightGoal : Double?
    @Published var stepsGoal : Double?
    @Published var dailyCaloriesGoal: Int?
    @Published var dailyFatsGoal: Int?
    @Published var dailyProteinGoal: Int?
    @Published var dailyCarbsGoal: Int?
    @Published var totalBreakfastCal: Int?
    @Published var totalLunchCal: Int?
    @Published var totalDinnerCal: Int?
    @Published var totalSnacksCal: Int?
    @Published var foodToday: [FoodToday] = []
    private var listener: ListenerRegistration?
    static let instance = UserGoals()
    
    init(_ weightGoal: Double? = nil, _ stepsGoal: Double? = nil) {
        self.weightGoal = weightGoal
        self.stepsGoal = stepsGoal
        fetchUserData() { _ in
        }
    }
    
    func fetchUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        print("2")
        if let currentUserEmail = Auth.auth().currentUser?.email {
            db.collection("UserInformations").document(currentUserEmail).getDocument { (document, error) in
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
                    let currentBreakfastCal = userData["currentBreakfastCal"]  as? Int ?? 0
                    let currentLunchCal = userData["currentLunchCal"]  as? Int ?? 0
                    let currentDinnerCal = userData["currentDinnerCal"] as? Int ?? 0
                    let currentSnacksCal = userData["currentSnacksCal"] as? Int ?? 0
                    let currentBurnedCal = userData["currentBurnedCal"] as? Int ?? 0
                    let weeklyGoal = userData["weeklyGoal"] as? Int ?? 0
                    let calorieGoal = userData["calorieGoal"] as? Int ?? 0
                    let caloriesConsumed = userData["caloriesConsumed"] as? Int ?? 0
                    let adviced = userData["adviced"] as? Bool ?? true
                    let goalWeight = userData["goalWeight"]  as? Int ?? 0
                    let dietaryType  = userData["dietaryType"] as? String ?? ""
                    
                    self.user = UserData(userEmail: userEmail, calorie: calorie, sex: sex, weight: weight, height:height, age: age, activeness: activeness, bmh: bmh, bmi: bmi, changeCalorieAmount: changeCalorieAmount, goalType: goalType, currentDay: currentDay, currentCarbs: currentCarbs, currentPro: currentPro, currentFat: currentFat, currentBreakfastCal: currentBreakfastCal, currentLunchCal: currentLunchCal, currentDinnerCal: currentDinnerCal, currentSnacksCal: currentSnacksCal, currentBurnedCal: currentBurnedCal, weeklyGoal: weeklyGoal, calorieGoal: calorieGoal, caloriesConsumed: caloriesConsumed, adviced: adviced, goalWeight: goalWeight, dietaryType: dietaryType)
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
        
        let documentRef = db.collection("foodToday").document(currentUserEmail)
        
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
            
            let dispatchGroup = DispatchGroup()
            var foodArray: [FoodToday] = []
            
            for foodData in foodDataArray {
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInitiated).async {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: foodData),
                       let food = try? JSONDecoder().decode(FoodToday.self, from: jsonData) {
                        foodArray.append(food)
                    } else {
                        print("Error serializing or decoding food data: \(foodData)")
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.foodToday = foodArray
                completion(foodArray)
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
        
        let totalAdjustedCalories = (totalBreakfastCal ?? 0) + (totalLunchCal ?? 0) + (totalDinnerCal ?? 0) + (totalSnacksCal ?? 0)
        let adjustment  = (dailyCaloriesGoal ?? 0) - totalAdjustedCalories
        if adjustment != 0 {
            totalBreakfastCal! += adjustment
        }
        
    }
    
    
    func updateAll(_ calories : Int?, _ fats: Int?, _ protein: Int?, _ carbs: Int?){
        dailyCaloriesGoal = calories
        dailyFatsGoal = fats
        dailyProteinGoal = protein
        dailyCarbsGoal = carbs
    }
}
