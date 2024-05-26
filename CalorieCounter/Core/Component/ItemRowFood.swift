//
//  ItomRowFood.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 26/5/24.
//

import SwiftUI

struct ItemRowFood: View {
    var foodToday: FoodToday
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(foodToday.name)
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                    .fontWeight(.medium)
                HStack {
                    Text(foodToday.amount)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                    Text("-  \(foodToday.calories) Kcal")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                }
                
            }
            Spacer()
            Button(action: {
                
            }, label: {
                Image("delete")
            })
            
        }
        .frame(width: Vconst.DESIGN_WIDTH_RATIO * 320)
        .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 10)
        .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO * 10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.white.opacity(0.5), radius: 10)
        .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO * 20)
//
        
        
    }
}

#Preview {
    ItemRowFood(foodToday: FoodToday(name: "Bánh gạo nếp", calories: 100, type: "Breakfast" , amount: "2 ly"))
}
