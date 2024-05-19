//
//  AddMealViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import Foundation
import SwiftUI

struct AddMealView: View {
    @ObservedObject var userGoals = UserGoals.instance
    @ObservedObject var viewModel = FoodViewModel.instance
    @ObservedObject var dailySummaryData = DailySummaryData.instance
    
    var foodSearchSuggestions = [String]()
    var  mealType: MealType
//    var  frequentFoods: [FoodStruct]?
    //@State var searchText = ""
    
    var body: some View {
        
        //NavigationView {
        VStack {
            //                ZStack{
            Text("\(mealType.title)")
                .font(.system(size: 17))
                .foregroundColor(.white)
            //                    SearchField(searchText: $viewModel.searchText)
            //                        .padding(.horizontal, 30)
            //                        .padding(.top, 30)
            
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.frequentFoods, id: \.self) { food in
                            FoodItemRowView(food: food, dailySummaryData: dailySummaryData, userGoals: userGoals, mealType: mealType)
                        }
                    }
                }
            }
    }
    
}

struct SearchField: View {
    @Binding var searchText: String
    var placeholder: LocalizedStringKey = "Search..."
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $searchText)
            //.offset(y: 10)
                .accentColor(.gray)
                .frame(height: Vconst.DESIGN_HEIGHT_RATIO * 30)
        }
        
        .foregroundColor(.gray)
        .padding(8)
        .background(Color.white)
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.top, 40)
        .padding(2)
        
        
    }
}


struct FoodItemRowView: View {
    @Environment(\.presentationMode) var presentationMode
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
                    .frame(width: Vconst.DESIGN_WIDTH_RATIO * 80, height: Vconst.DESIGN_HEIGHT_RATIO * 80)
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
                print("food\(food)")
//                dailySummaryData.totalCalories += Int(food.calorie ?? 0)
//                dailySummaryData.totalCarbs += Int(food.carbs ?? 0)
//                dailySummaryData.totalFats += Int(food.fat ?? 0)
//                dailySummaryData.totalProteins += Int(food.protein ?? 0)
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
                
                self.presentationMode.wrappedValue.dismiss()
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
        AddMealView(viewModel: FoodViewModel(), mealType: .lunch)
        //            .environmentObject(FDCDayMeals())
    }
}
