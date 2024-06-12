//
//  FoodMapper.swift
//  CalorieCounter
//
//  Created by  on 10/06/2024.
//

import Foundation

class FoodMapper {
    static func firestoreToFoods(id: String?, data: [String:Any]) -> Foods {
        return Foods(id: id ?? data["id"] as? String ?? UUID().uuidString,
                     amount: data["amount"] as? String ?? "",
                     calorie: data["calorie"] as? Float ?? 0,
                     carbohydrate: data["carbohydrate"] as? Float ?? 0,
                     fat: data["fat"] as? Float ?? 0,
                     fiber: data["fiber"] as? Float ?? 0,
                     name: data["name"] as? String ?? "",
                     protein: data["protein"] as? Float ?? 0
        )
    }
}
