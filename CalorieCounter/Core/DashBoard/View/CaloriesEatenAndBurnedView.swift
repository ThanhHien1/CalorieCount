//
//  CaloriesEatenAndBurnedView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import SwiftUI
import SwiftData

struct CaloriesEatenAndBurnedView: View {
    @ObservedObject var viewModel =  DailySummaryData.instance
    @ObservedObject var healthStore =  HealthStore()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Calorie Progress")
                .font(.subheadline)
            HStack {
                VStack {
                    
                    Text(viewModel.totalCalories.formatted())
                        .font(.system(size: 24))
                    HStack {
                        Text("Eaten")
                            .font(.caption)
                        Image(systemName: "heart.fill")
                        
                    }
                }
                
                Spacer()
                CircularProgressView(progress: viewModel.progressCalories, remainingCalories: viewModel.remainingCalories)
                
                Spacer()
                
                VStack {
                    if let caloriesBurned = healthStore.caloriesBurnedToday {
                        Text(caloriesBurned.formatted())
                            .font(.system(size: 24))
                        HStack {
                            Text("Burned")
                                .font(.caption)
                            Image(systemName: "flame")
                        }
                        
                    } else {
                        Text("0")
                            .font(.system(size: 24))
                        HStack {
                            Text("Burned")
                                .font(.caption)
                            Image(systemName: "flame")
                        }
                    }
                }
            }
            .foregroundStyle(.orange)
            .padding()
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .onAppear {
                viewModel.updateConSumedCalories()
                viewModel.updateRemainingCalories()
//                viewModel.updateNutrition(foods, userGoals)
//                healthStore.readTodaysActivity()
            }
        }
        .padding()
    }
}

#Preview {
    CaloriesEatenAndBurnedView()
}

