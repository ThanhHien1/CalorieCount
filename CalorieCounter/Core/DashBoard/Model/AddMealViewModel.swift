//
//  AddMealViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import Foundation
import SwiftUI
import Combine

class AddMealViewModel: ObservableObject {
    @Published var frequentFoods: [FoodStruct]?
    @Published var foodSearchSuggestions: [FoodStruct]?

    
}
