//
//  MacroProgressCardView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation
import SwiftUI

struct MacroProgressCardView: View {
    
    var title: String
    var value: Int
    var total: Int
    var color: Color
    var valueInGrams: Int
    var totalInGrams: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 14))
            ProgressView(value: Double(value), total: Double(total))
                .tint(color)
            Text("\(valueInGrams) / \(totalInGrams) g")
                .font(.system(size: 12))
        }
    }
}


