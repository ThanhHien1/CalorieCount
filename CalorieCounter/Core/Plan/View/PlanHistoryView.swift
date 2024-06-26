//
//  TodayHistoryView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 8/6/24.
//

import Foundation
import SwiftUI

struct PlanHistoryView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userGoal = UserGoals.instance
    @StateObject var viewmodel: PlanViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewmodel.allPlan, id: \.self){ plan in
                        Text(plan.date).font(.headline)
                            .foregroundStyle(Color.cl_F24F1D())
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        ItemFoodPlan(title: MealType.breakfast.title, foods: plan.breakfast)
                        
                        ItemFoodPlan(title: MealType.lunch.title, foods: plan.lunch)
                        
                        ItemFoodPlan(title: MealType.dinner.title, foods: plan.dinner)
                        
                        ItemFoodPlan(title: MealType.snacks.title, foods: plan.snacks)
                    }
                }
                .padding(.top, 5)
            }
            .padding(.top, 10)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

struct ItemFoodPlan: View {
    var title: String
    var foods: [Foods]
    var eatAction: ((Foods) -> Void)? = nil
    
    var body: some View{
        if foods.isEmpty {
            Spacer().frame(height: 2)
        } else {
            VStack(alignment: .leading){
                Text(title).font(.headline)
                    .padding(.horizontal, 15)
                    .padding(.top, 5)
                ForEach(foods, id: \.self) { food in
                    PlanFoodItemRow(food: food, mealType: .breakfast, eatAction: eatAction)
                }
            }
        }
    }
}
    
#Preview {
    PlanHistoryView(viewmodel: .init())
}

