//
//  AddMealViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 1/5/24.
//

import Foundation
import SwiftUI

struct AddMealView: View {
    @ObservedObject var viewModel: FoodViewModel
    var foodSearchSuggestions = [String]()
    var  mealType: MealType = .breakfast
    //@State var searchText = ""
    
    var body: some View {
        
        //NavigationView {
            VStack {
                ZStack{
                    
                    RoundedCorners(tl: 0, tr: 0, bl: 64, br: 0, mealType: .breakfast)
//                        .modifier(GradientModifier(mealType: $viewModel.mealType))
                        .frame(height: 202)
                        .frame(maxWidth: .infinity)
                    
                    
                    SearchField(searchText: $viewModel.searchText)
                        .padding(.horizontal, 30)
                        .padding(.top, 50)
                    
                    Text("\(mealType.title)")
                        .offset(y: -30)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                }
                
                ScrollView {
                              LazyVStack {
                                  ForEach(viewModel.frequentFoods, id: \.self) { food in
                                      FoodItemRowView(food: food)
                                  }
                              }
                          }
                      }
                      .background(Color(#colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9803921569, alpha: 1)))
                      .edgesIgnoringSafeArea(.all)
            .edgesIgnoringSafeArea(.all)
//            .modifier(DismissingKeyboardOnSwipe())
            //.navigationBarHidden(true)
            .navigationBarTitle("Back")
            .onAppear() {
                
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
                .frame(height: 30)
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
    var food: FoodStruct
    
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
                // Handle adding the meal
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
        AddMealView(viewModel: FoodViewModel())
//            .environmentObject(FDCDayMeals())
    }
}
