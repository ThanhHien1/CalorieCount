//
//  PlanView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 8/6/24.
//

import Foundation

import SwiftUI
import KRProgressHUD

struct PlanView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var userGoals = UserGoals.instance
    @StateObject var viewmodel: PlanViewModel
    @ObservedObject var goalViewModel = GoalViewModel.instance
    @ObservedObject var dailySummaryData = DailySummaryData.instance
    @State var isActive = false
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack {
                    ItemFoodPlan(
                        title: MealType.breakfast.title,
                        foods: viewmodel.planToday.breakfast,
                        eatAction: { food in
                            saveFood(food: food, mealType: .breakfast)
                        }
                    )
                    
                    ItemFoodPlan(
                        title: MealType.lunch.title,
                        foods: viewmodel.planToday.lunch,
                        eatAction: { food in
                            saveFood(food: food, mealType: .lunch)
                        }
                    )
                    
                    ItemFoodPlan(
                        title: MealType.dinner.title,
                        foods: viewmodel.planToday.dinner,
                        eatAction: { food in
                            saveFood(food: food, mealType: .dinner)
                        }
                    )
                    
                    ItemFoodPlan(
                        title: MealType.snacks.title,
                        foods: viewmodel.planToday.snacks,
                        eatAction: { food in
                            saveFood(food: food, mealType: .snacks)
                        }
                    )
                }
                .padding(.top, 5)
            }
            .padding(.top, 10)
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .onAppear(perform: {
            viewmodel.listenPlanToday()
        })
        .onDisappear(perform: {
            viewmodel.clearSnapshotListener()
        })
        .navigationDestination(isPresented: $isActive) {
            TabBarView()
        }
    }
}

extension PlanView {
    
    func saveFood(food: Foods, mealType: MealType) {
        KRProgressHUD.show()
        userGoals.user?.caloriesConsumed += Int(food.calorie)
        userGoals.user?.currentFat += Int(food.fat)
        userGoals.user?.currentPro += Int(food.protein)
        userGoals.user?.currentCarbs += Int(food.carbohydrate)
        let foodToday = FoodToday(id: UUID().uuidString, foods: [food], type: mealType.title)
        goalViewModel.saveFoodToday(newFood: foodToday) {_ in 
            userGoals.fetchFoodToday() { foodToday  in
                goalViewModel.updateUserData(user: userGoals.user!) {
                    KRProgressHUD.dismiss()
                    isActive = true
                }
            }
        }
    }
}

struct PlanFoodItemRow: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var goalViewModel = GoalViewModel.instance
    var food: Foods
    var mealType: MealType
    var eatAction: ((Foods) -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.black)
                HStack {
                    Text(food.amount)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                    Text("-  \(Int(food.calorie)) Kcal")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                }
            }
            Spacer()
            if eatAction != nil {
                Button(action: {
                    eatAction?(food)
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 24))
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)

    }
}

#Preview {
    PlanView(viewmodel: .init())
}
