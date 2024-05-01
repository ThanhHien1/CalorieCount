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
    var foods : [Foods] = []
    var userGoals  = UserGoals.instance
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Macro Progress")
                .font(.subheadline)
            HStack(spacing: 30) {
                MacroProgressCardView(title: "Carbs",
                                      value: viewModel.totalCarbs,
                                      total:  userGoals.dailyCarbsGoal ?? 0,
                                      color: Color.mint,
                                      valueInGrams: viewModel.totalCarbs,
                                      totalInGrams: userGoals.dailyCarbsGoal ?? 0)
                MacroProgressCardView(title: "Protein",
                                      value: viewModel.totalProteins,
                                      total:  userGoals.dailyProteinGoal ?? 0,
                                      color: Color.indigo,
                                      valueInGrams: viewModel.totalProteins,
                                      totalInGrams: userGoals.dailyProteinGoal ?? 10)
                MacroProgressCardView(title: "Fat",
                                      value: viewModel.totalFats,
                                      total:  userGoals.dailyFatsGoal ?? 0,
                                      color: Color.orange,
                                      valueInGrams: viewModel.totalFats,
                                      totalInGrams: userGoals.dailyFatsGoal ?? 0)
                
            }
            .padding()
            .frame(width: Vconst.DESIGN_WIDTH_RATIO * 350)
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous)
            )
            
            .onAppear {
                viewModel.updateNutrition(foods, userGoals)
            }
        }
        .padding(.leading, 10)
        
    }
}

#Preview {
    Nutritient_Card()
}

