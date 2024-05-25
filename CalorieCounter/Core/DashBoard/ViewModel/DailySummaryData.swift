//
//  DailySummaryData.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreInternal

class DailySummaryData: ObservableObject {
    let db = Firestore.firestore()
    var selectedDate = Date()
    @Published var totalCalories = 0
    @Published var totalFats = 0
    @Published var totalProteins = 0
    @Published var totalCarbs = 0
    @Published var remainingCalories = 0
    @Published var progressCalories: Double = 0.0
    var currentUserGoals =  UserGoals.instance
    static let instance = DailySummaryData()
    
    func progressSteps() -> Double {
        if let dailyStepsGoal = currentUserGoals.stepsGoal {
            return dailyStepsGoal
        }
        return 0.0
    }
    
    func updateRemainingCalories() {
        var dailyCaloriesGoal = (currentUserGoals.user?.calorie ?? 0)
            print("dailyCaloriesGoal1111 \(dailyCaloriesGoal)")
            self.remainingCalories =  dailyCaloriesGoal - totalCalories
        
        if let dailyCaloriesGoal = currentUserGoals.user?.calorie {
            progressCalories =  Double(totalCalories)/Double(dailyCaloriesGoal)
        }
    }
    
    func updateConSumedCalories() {
       totalCalories = (currentUserGoals.user?.caloriesConsumed ?? 0)
        totalCarbs = (currentUserGoals.user?.currentCarbs ?? 0)
        totalProteins = (currentUserGoals.user?.currentPro ?? 0)
        totalFats = (currentUserGoals.user?.currentFat ?? 0)
    }

    func updateNutrition(_ food: FoodStruct) {
        totalCalories += Int(food.calorie ?? 0)
        totalFats += Int(food.fat ?? 0)
        print("totalFats \(totalFats)")
        totalProteins += Int(food.protein ?? 0)
        totalCarbs += Int(food.carbs ?? 0)
    }

    
   
}
