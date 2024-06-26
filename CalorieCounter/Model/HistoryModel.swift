//
//  HistoryModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 26/06/2024.
//

import Foundation

struct HistoryModel: Codable, Hashable {
    var date: String = ""
    var foods: [FoodToday] = []
    var totalCalories: Float = 0.0
    var target: Double = 0.0
}
