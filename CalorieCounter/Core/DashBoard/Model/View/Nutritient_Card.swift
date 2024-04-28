//
//  Nutritient_Card.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import SwiftUI
import SwiftData

struct Nutritient_Card: View {
    
    @ObservedObject var viewModel =  DailySummaryData()
    var foods : [Food] = []
    var userGoals : [UserGoals] = []
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Macro Progress")
                .font(.subheadline)
            HStack(spacing: 30) {
                MacroProgressCardView(title: "Fat",
                                      value: viewModel.totalFats,
//                                      total: userGoals[0].dailyFatsGoal ?? 0,
                                      total:  0,
                                      color: Color.orange,
                                      valueInGrams: viewModel.totalFats,
//                                      totalInGrams: userGoals[0].dailyFatsGoal ?? 0)
                                      totalInGrams: 0)
                MacroProgressCardView(title: "Protein",
                                      value: viewModel.totalProteins,
                                      total:  0,
                                      color: Color.indigo,
                                      valueInGrams: viewModel.totalProteins,
                                      totalInGrams: 0)
                
                MacroProgressCardView(title: "Carbs",
                                      value: viewModel.totalCarbs,
                                      total: 0,
                                      color: Color.mint,
                                      valueInGrams: viewModel.totalCarbs,
                                      totalInGrams: 0)
                        }
            .padding()
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            
            .onAppear {
                viewModel.updateNutrition(foods, userGoals)
            }
        }
        .padding()
        
    }
}
