//
//  PanModel.swift
//  CalorieCounter
//
//  Created by on 10/06/2024.
//

import Foundation

struct PlanModel: Codable, Hashable{
    var date: String = ""
    var breakfast: [Foods] = []
    var lunch: [Foods] = []
    var dinner: [Foods] = []
    var snacks: [Foods] = []
}
