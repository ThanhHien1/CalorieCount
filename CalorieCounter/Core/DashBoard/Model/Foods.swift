//
//  Food.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation


struct Foods: Hashable {
    
    var amount : String
    var calorie : Float
    var carbohydrate : Float
    var fat : Float
    var fiber : Float
    var name : String
    var protein : Float
    
    
//    init(_ name: String, _ category: String, _ calories: String, _ fats: String?, _ protein: String?, _ carbohydrate: String?, _ mealTime: String) {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        self.date = dateFormatter.string(from: Date())
//        
//        self.name = name
//        self.category = category
//        self.calories = calories
//        self.fats = fats
//        self.protein = protein
//        self.carbohydrate = carbohydrate
//        self.mealTime = mealTime
//    }
//    
//    static let mealTimes = [
//        "Breakfast",
//        "Lunch",
//        "Dinner",
//        "Snack",
//        "Other"
//    ]
//    
//    
//    static let sectionTitles = [
//        "Food Name",
//        "Calories",
//        "Fats",
//        "Carbohydrates",
//        "Proteins"
//    ]
//
//    static let textFieldPlaceholders = [
//        "(Required) Enter Food name",
//        "(Required) Enter Calories",
//        "(Optional) Enter Fats",
//        "(Optional) Enter Carbs",
//        "(Optional) Enter Proteins"
//    ]
//    
//    static let foodCategories = ["Breakfast", "Lunch", "Dinner", "Sweets", "Drinks", "Other"]

}


// Mark : Workaround to using predicates and dates. Predicates do not work with dates right now
extension Food {

//    @available(iOS 17, *)
//    static func currentPredicate() -> Predicate<Foods> {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let dateStringOne = dateFormatter.string(from: Date())
//            
////        return #Predicate<Foods> { food in
////            food.date == dateStringOne
////        }
//    }
}
