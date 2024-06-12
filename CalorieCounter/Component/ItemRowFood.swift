//
//  ItomRowFood.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 26/5/24.
//

import SwiftUI

struct ItemRowFood: View {
    @ObservedObject var foodViewModel = FoodViewModel.instance
//    var idFood: String
    @State var foods: Foods
    var onDelete: (() -> Void)?
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(foods.name)
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                    .fontWeight(.medium)
                HStack {
                    Text(foods.amount)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                    Text("-  \(Int(foods.calorie)) Kcal")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                }
                
            }
            Spacer()
            Button(action: {
                onDelete?()
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
        .onAppear {
//                  foodViewModel.getFoodFromID(id: idFood) {
//                      food = foodViewModel.food
                
//            }
        }
        
        
    }
}

#Preview {
    ItemRowFood(foods: Foods(id: "1", amount: "2", calorie: 1, carbohydrate: 1, fat: 1, fiber: 1, name: "2", protein: 1))
}
