//
//  AddMealViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import SwiftUI

struct AddMealView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = AddMealViewModel()
    @ObservedObject var goalViewModel = GoalViewModel.instance
    @ObservedObject var userGoals = UserGoals.instance
    @ObservedObject var foodViewModel = FoodViewModel.instance
    @ObservedObject var dailySummaryData = DailySummaryData.instance
    @State var searchText = ""
    var mealType: MealType
    var body: some View {
        if #available(iOS 17.0, *) {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack {
                        ForEach(searchText.isEmpty ? viewModel.frequentFoods ?? [] :viewModel.foodSearchSuggestions ?? [], id: \.self) { food in
                            FoodItemRowView(food: food, dailySummaryData: dailySummaryData, userGoals: userGoals, mealType: mealType)
                        }
                    }
                    .padding(.top, 5)
                }
                .padding(.top, 10)
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .searchable(text: $searchText) {}
            .onChange(of: searchText) {
                print("######")
                performSearch()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: .black) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("\(mealType.title)")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                viewModel.frequentFoods = foodViewModel.foods
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension AddMealView {
    
    func performSearch() {
        let searchQuery  = searchText
        if !searchQuery.isEmpty {
//            viewModel.frequentFoods =  foodViewModel.foods
//        } else {
            foodViewModel.searchFood(searchQuery: searchQuery) { searchFood in
                viewModel.foodSearchSuggestions =  searchFood
                print("########## searchFood \(viewModel.foodSearchSuggestions)")
            }
        }
    }
}

struct FoodItemRowView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var goalViewModel = GoalViewModel.instance
    var food: Foods
    var dailySummaryData: DailySummaryData
    var userGoals: UserGoals
    var mealType: MealType
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.headline)
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
            Button(action: {
                dailySummaryData.updateNutrition(food)
                switch mealType {
                case .breakfast:
                    userGoals.totalBreakfastCal! -= Int(food.calorie ?? 0)
                case .lunch:
                    userGoals.totalLunchCal! -= Int(food.calorie ?? 0)
                case .dinner:
                    userGoals.totalDinnerCal! -= Int(food.calorie)
                case .snacks:
                    userGoals.totalSnacksCal! -= Int(food.calorie)
                }
                
                userGoals.user?.caloriesConsumed += Int(food.calorie)
                userGoals.user?.currentFat += Int(food.fat)
                userGoals.user?.currentPro += Int(food.protein)
                userGoals.user?.currentCarbs += Int(food.carbohydrate)
                let foodToday = FoodToday(name: food.name, calories: Int(food.calorie.rounded()), type: mealType.title, amount: food.amount )
                goalViewModel.saveFoodTodayData(foodToday: [foodToday], completion: {_ in
                    print("######")
                    userGoals.fetchFoodToday() { foodToday,error  in
                        print("######\(foodToday?.count)")
                        
                    }
                })
                
                goalViewModel.updateUserData(user: userGoals.user!) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 24))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.horizontal, 8)
        .padding(.horizontal, 16)
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(foodViewModel: FoodViewModel(), mealType: .lunch)
    }
}
