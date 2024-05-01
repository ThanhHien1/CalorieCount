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
    var totalCalories = 0
    var totalFats = 0
    var totalProteins = 0
    var totalCarbs = 0
    var currentUserGoals =  UserGoals.instance
    static let instance = DailySummaryData()
    
   
    var remainingCalories: Int? {
        if let dailyCaloriesGoal = currentUserGoals.dailyCaloriesGoal {
            return dailyCaloriesGoal - totalCalories
        }
        return nil
    }
    
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

    func updateNutrition(_ foods : [Food], _ userGoals : UserGoals){
        
        if foods.isEmpty { return }
        
        totalCalories = foods.reduce(0, {$0 + (Int($1.calories) ?? 0)})
        totalFats = foods.reduce(0, {$0 + (Int($1.fats ?? "") ?? 0)})
        totalProteins = foods.reduce(0, {$0 + (Int($1.protein ?? "") ?? 0)})
        totalCarbs = foods.reduce(0, {$0 + (Int($1.carbohydrate ?? "") ?? 0)})
        
//        if userGoals.isEmpty { return }
        
        currentUserGoals = userGoals
    }
    
    
   
}
