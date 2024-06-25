//
//  AddMealViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import SwiftUI
import KRProgressHUD

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
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack {
                        ForEach(searchText.isEmpty ? viewModel.frequentFoods ?? [] :viewModel.foodSearchSuggestions ?? [], id: \.self) { food in
                            FoodItemRowView(food: food, dailySummaryData: dailySummaryData, userGoals: userGoals, mealType: mealType)
                        }
                    }
//                    .padding(.top, 5)
                }
                Spacer()
            }
            .onAppear {
                print("%%%% \(foodViewModel.foods.count)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    viewModel.frequentFoods = foodViewModel.foods
                }
            }
            .navigationBarBackButtonHidden()
            .searchable(text: $searchText) {}
            .onChange(of: searchText, perform: { value in
                performSearch()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: .black) {
                        self.presentationMode.wrappedValue.dismiss()
                    }.frame(height: 20)
                }
                ToolbarItem(placement: .principal) {
                    Text("\(mealType.title)")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .frame(height: 20)
                }
            }.navigationBarTitleDisplayMode(.inline)
    }
}

extension AddMealView {
    
    func performSearch() {
        let searchQuery  = searchText
        if !searchQuery.isEmpty {
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
        NavigationLink(destination: DetailFood(food: food)) {
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
                    KRProgressHUD.show()
                    dailySummaryData.updateNutrition(food)
                    switch mealType {
                    case .breakfast:
                        userGoals.totalBreakfastCal -= Int(food.calorie)
                    case .lunch:
                        userGoals.totalLunchCal -= Int(food.calorie)
                    case .dinner:
                        userGoals.totalDinnerCal -= Int(food.calorie)
                    case .snacks:
                        userGoals.totalSnacksCal -= Int(food.calorie)
                    }
                    
                    userGoals.user?.caloriesConsumed += Int(food.calorie)
                    userGoals.user?.currentFat += Int(food.fat)
                    userGoals.user?.currentPro += Int(food.protein)
                    userGoals.user?.currentCarbs += Int(food.carbohydrate)
                    let foodToday = FoodToday(id: UUID().uuidString, foods: [food], type: mealType.title)
                    goalViewModel.saveFoodToday(newFood: foodToday) {
                        userGoals.fetchFoodToday() { foodToday  in
                            goalViewModel.updateUserData(user: userGoals.user!) {
                                KRProgressHUD.dismiss()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
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
        }
    }
}

struct AddMealView_Previews: PreviewProvider {
    static var previews: some View {
        AddMealView(foodViewModel: FoodViewModel(), mealType: .lunch)
    }
}
