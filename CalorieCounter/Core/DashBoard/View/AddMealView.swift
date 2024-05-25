//
//  AddMealViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import SwiftUI

struct AddMealView: View {
    @ObservedObject var viewModel = AddMealViewModel()
    @ObservedObject var goalViewModel = GoalViewModel.instance
    @ObservedObject var userGoals = UserGoals.instance
    @ObservedObject var foodViewModel = FoodViewModel.instance
    @ObservedObject var dailySummaryData = DailySummaryData.instance
    @State var searchText = ""
    var mealType: MealType
    
    var body: some View {
        VStack {
            Text("\(mealType.title)")
                .font(.system(size: 17))
                .foregroundColor(.white)
            
            // Search Bar with onCommit
//            TextField("Search for food", text: $searchText, onCommit: {
//                performSearch()
//            })
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .padding(.horizontal, 30)
//            .padding(.top, 10)
//            
            ScrollView {
                Spacer().frame(height: 5)
                LazyVStack {
                    ForEach(searchText.isEmpty ? viewModel.frequentFoods ?? [] :viewModel.foodSearchSuggestions ?? [], id: \.self) { food in
                        FoodItemRowView(food: food, dailySummaryData: dailySummaryData, userGoals: userGoals, mealType: mealType)
                    }
                }
                .searchable(text: $searchText) {
                    
                }
                .onSubmit(of: .search) {
                    performSearch()
                }
            }
        }
        .onAppear {
            viewModel.frequentFoods = foodViewModel.frequentFoods
        }
    }
    
    // Perform search when Enter key is pressed
    func performSearch() {
        let searchQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            foodViewModel.clearData()
            let configuredQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
            foodViewModel.fetchSearchedFoodData(searchQuery: configuredQuery, pagination: false) {
                viewModel.foodSearchSuggestions = foodViewModel.getFoods()
                print(" viewModel.foodSearchSuggestions \( viewModel.foodSearchSuggestions?.count)")
            }
        }
    }
}

struct FoodItemRowView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var goalViewModel = GoalViewModel.instance
    var food: FoodStruct
    var dailySummaryData: DailySummaryData
    var userGoals: UserGoals
    var mealType: MealType
    
    var body: some View {
        HStack(spacing: 10) {
            if let uiImage = UIImage(data: food.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.label ?? "")
                    .font(.headline)
                Text("\(Int(food.calorie ?? 0)) Calories")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
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
                    userGoals.totalDinnerCal! -= Int(food.calorie ?? 0)
                case .snacks:
                    userGoals.totalSnacksCal! -= Int(food.calorie ?? 0)
                }
                
                userGoals.user?.caloriesConsumed += Int(food.calorie ?? 0)
                userGoals.user?.currentFat += Int(food.fat ?? 0)
                userGoals.user?.currentPro += Int(food.protein ?? 0)
                userGoals.user?.currentCarbs += Int(food.carbs ?? 0)
                
                goalViewModel.updateUserData(user: userGoals.user!) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 24))
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.horizontal, 8)
        .padding(.horizontal, 16)
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(foodViewModel: FoodViewModel(), mealType: .lunch)
    }
}
