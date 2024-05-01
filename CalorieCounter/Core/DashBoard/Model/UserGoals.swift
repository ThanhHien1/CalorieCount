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

class UserGoals {
    
    let db = Firestore.firestore()
    var user: UserData? = nil
    var weightGoal : Double?
    var stepsGoal : Double?
    var dailyCaloriesGoal: Int?
    var dailyFatsGoal: Int?
    var dailyProteinGoal: Int?
    var dailyCarbsGoal: Int?
    var totalBreakfastCal: Int?
    var totalLunchCal: Int?
    var totalDinnerCal: Int?
    var totalSnacksCal: Int?
    static let instance = UserGoals()
    
    init(_ weightGoal: Double? = nil, _ stepsGoal: Double? = nil) {
        self.weightGoal = weightGoal
        self.stepsGoal = stepsGoal
        fetchUserData() { _ in
            
        }
    }
    
    
    func fetchUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        print("%%%%%%%%%")
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
                    let bmh = userData["bmh"] as? Float ?? 0.0
                    let changeCalorieAmount = userData["changeCalorieAmount"] as? Int ?? 0
                    let goalType = userData["goalType"] as? String ?? ""
                    let currentDay = userData["currentDay"] as? Date ?? Date()
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
                    let adviced = userData["adviced"] as? Bool ?? true
                    let goalWeight = userData["goalWeight"]  as? Int ?? 0
                    let dietaryType  = userData["dietaryType"] as? String ?? ""
                    
                    self.user = UserData(userEmail: userEmail, calorie: calorie, sex: sex, weight: weight, height: height, age: age, bmh: bmh, changeCalorieAmount: changeCalorieAmount, goalType: goalType, currentDay: currentDay, currentCarbs: currentCarbs, currentPro: currentPro, currentFat: currentFat, currentBreakfastCal: currentBreakfastCal, currentLunchCal: currentLunchCal, currentDinnerCal: currentDinnerCal, currentSnacksCal: currentSnacksCal, currentBurnedCal: currentBurnedCal, weeklyGoal: weeklyGoal, calorieGoal: calorieGoal, adviced: adviced, goalWeight: goalWeight, dietaryType: dietaryType)
                    self.dailyCaloriesGoal = self.user?.calorie ?? 0
                    print("dailyCaloriesGoal \(self.dailyCaloriesGoal)")
                    self.calculateTotalCalNeeds()
                    //                    completion(.success(user ?? <#default value#>))
                } catch let parsingError {
                    completion(.failure(parsingError))
                }
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
    }
    
    
    func updateAll(_ calories : Int?, _ fats: Int?, _ protein: Int?, _ carbs: Int?){
        dailyCaloriesGoal = calories
        dailyFatsGoal = fats
        dailyProteinGoal = protein
        dailyCarbsGoal = carbs
    }
}
