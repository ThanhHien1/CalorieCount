//
//  DetailFoodHistory.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 26/6/24.
//

import SwiftUI

struct DetailFoodHistory: View {
    
    var foodToday: [FoodToday] = []

    var body: some View {
        VStack {
            ScrollView {
                Text("Danh sách thực phẩm đã ăn").font(.headline)
                Group {
                    if !breakFirst.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Buổi sáng")
                                .font(.headline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                            ForEach(breakFirst, id: \.id) { foodToday in
                                PlanFoodItemRow(food: foodToday.foods[0], mealType: .breakfast)
                            }
                        }
                    }
                    
                    if !lunch.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Buổi trưa")
                                .font(.headline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                            ForEach(lunch, id: \.id) { foodToday in
                                PlanFoodItemRow(food: foodToday.foods[0], mealType: .lunch)
                            }
                        }
                    }
                    
                    if !dinner.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Buổi tối")
                                .font(.headline)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                            ForEach(dinner, id: \.id) { foodToday in
                                PlanFoodItemRow(food: foodToday.foods[0],  mealType: .dinner)
                            }
                        }
                    }
                    
                    if !snack.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bữa phụ")
                                .font(.headline)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                            ForEach(snack, id: \.id) { foodToday in
                                PlanFoodItemRow(food: foodToday.foods[0], mealType: .snacks)
                            }
                        }
                    }
                }
            }
        }
//        navigationBarTitleDisplayMode(.inline)
//        .padding(.top, 20)
        Spacer()
       
    }
}

extension DetailFoodHistory {
    
    var breakFirst: [FoodToday] {
        foodToday.filter { $0.type == "Bữa sáng" }
    }
    var lunch: [FoodToday] {
        foodToday.filter { $0.type == "Bữa trưa" }
    }
    var dinner: [FoodToday] {
        foodToday.filter { $0.type == "Bữa tối" }
    }
    var snack: [FoodToday] {
        foodToday.filter { $0.type == "Bữa phụ" }
    }
}

#Preview {
    DetailFoodHistory()
}
