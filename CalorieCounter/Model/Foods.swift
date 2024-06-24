//
//  Food.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation


struct Foods: Hashable, Encodable, Decodable {
    var id: String
    var amount : String
    var calorie : Float
    var carbohydrate: Float
    var fat : Float
    var fiber : Float
    var name : String
    var protein : Float
    
}
