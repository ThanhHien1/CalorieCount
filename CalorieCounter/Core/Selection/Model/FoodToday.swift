//
//  Food.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 25/5/24.
//

import Foundation

//struct FoodToday: Hashable {
//    var name: String
//    var calories: Int
//    var type: String
//    var amount: String
//}

struct FoodToday: Hashable, Encodable, Decodable  {
    var foods: [Foods]
    var type: String
}

struct History: Hashable, Encodable, Decodable  {
    var listFood: [FoodToday]
    var date: String
    var totalCalorie: Int
}
