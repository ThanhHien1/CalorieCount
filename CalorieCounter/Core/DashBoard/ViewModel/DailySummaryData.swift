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
    var currentUserGoals =  UserGoals.instance
    static let instance = DailySummaryData()

   
    var progressCalories : Double {
        if let dailyCaloriesGoal = currentUserGoals.dailyCaloriesGoal {
            return Double(totalCalories)/Double(dailyCaloriesGoal)
        }
        return 0.0
    }
    
    func progressSteps() -> Double {
        if let dailyStepsGoal = currentUserGoals.stepsGoal {
            return dailyStepsGoal
        }
        return 0.0
    }
    
    func updateRemainingCalories() {
        if let dailyCaloriesGoal = currentUserGoals.user?.calorie {
            print("dailyCaloriesGoal1111 \(dailyCaloriesGoal)")
            self.remainingCalories =  dailyCaloriesGoal - totalCalories
        }
    }

    func updateNutrition(_ food: FoodStruct) {
        totalCalories += Int(food.calorie ?? 0)
        totalFats += Int(food.fat ?? 0)
        print("totalFats \(totalFats)")
        totalProteins += Int(food.protein ?? 0)
        totalCarbs += Int(food.carbs ?? 0)
    }

    
   
}
