//
//  Number.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import Foundation

class Number{
    static func randomFiveElements<T>(from array: [T], num: Int) -> [T] {
        let shuffledArray = array.shuffled()
        let count = min(num, array.count)
        return Array(shuffledArray.prefix(count))
    }
}
