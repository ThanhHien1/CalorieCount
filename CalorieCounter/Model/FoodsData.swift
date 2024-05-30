//
//  FoodsData.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import Foundation
import UIKit

struct FoodsData: Decodable {
    let text: String?
    let parsed: [ParsedData]?
    let hints: [FoodData]
    let _links: NextPageData
    
    private enum CodingKeys: String, CodingKey {
        case text
        case parsed
        case hints
        case _links
    }
}
struct ParsedData: Decodable {
    let food: Food
    
    private enum CodingKeys: String, CodingKey {
        case food = "food"
    }
}

struct FoodData: Decodable {
    let food: Food
    let measures: [Measure]
    private enum CodingKeys: String, CodingKey {
        case food
        case measures
    }
}

struct Measure: Decodable {
    let label: String?
    let weight: Float?
    
    private enum CodingKeys: String, CodingKey {
        case label
        case weight
    }
}

struct Food: Decodable, Identifiable {
    let id = UUID()
    let foodId: String?
    let label: String?
    let knownAs: String?
    let nutrients: Nutrients?
    let category: String?
    let categoryLabel: String?
    let image: String? // URL for API call to get UIImage object
    
    private enum CodingKeys: String, CodingKey {
        case foodId
        case label
        case knownAs
        case nutrients
        case category
        case categoryLabel
        case image
    }
}

struct Nutrients: Decodable {
    let ENERC_KCAL: Float?
    let PROCNT: Float?
    let FAT: Float?
    let CHOCDF: Float?
    let FIBTG: Float?
    
    private enum CodingKeys: String, CodingKey {
        case ENERC_KCAL
        case PROCNT
        case FAT
        case CHOCDF
        case FIBTG
    }
}
    
struct NextPageData: Decodable {
    let next: NextPage?
    
    
    private enum CodingKeys: String, CodingKey {
        case next = "next"
    }
}

struct NextPage: Decodable {
    let href: String?
    
    private enum CodingKeys: String, CodingKey {
        case href
    }
}

//Food Cell'e Aktarılacak Bilgiler
struct FoodStruct: Hashable {
    let label: String?
    let calorie: Float?
    let image: Data // URL for API call to get UIImage object
    let carbs: Float?
    let fat: Float?
    let protein: Float?
    let wholeGram: Float?
    let measureLabel: String?
}
