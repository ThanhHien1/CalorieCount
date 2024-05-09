//
//  DashBoardView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation
import SwiftUI

struct DashBoardView: View {
    private var foodViewModel = FoodViewModel()
    
    @State  var mealTypes: MealType = .breakfast
    @State var isActive: Bool = false
    var userGoals  = UserGoals.instance
    
    var body: some View {
        NavigationStack{
            VStack {
                CaloriesEatenAndBurnedView()
                Nutritient_Card()
                //                StepsProgressView()
//                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("Meals today")
                        .padding(.leading, 25)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            
                            ForEach(MealType.allCases, id: \.self ) { mealType in
                                carouselItem(mealType: mealType)
                            }
                        }
                        .background(NavigationLink("", destination: AddMealView(frequentFoods: foodViewModel.frequentFoods, mealType: mealTypes), isActive: $isActive).hidden())
                        .padding(.bottom, 60)
                        .padding(.horizontal, 30)
                    }
                    
                }
                .padding(.top, 20)
            }
            .background(
                LinearGradient(colors: [Color.white.opacity(0.7), Color.orange.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), ignoresSafeAreaEdges: [.top,.leading,.trailing])
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Image(systemName: "bell").badge(4)
                    Image(systemName: "person").badge(2)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("calorieHub")
                        .font(.system(size: 24))
                        .foregroundStyle(.orange)
                }
            }
            .navigationTitle("Today")
            
        }
    }
}

extension DashBoardView {
    
    private func carouselItem(mealType: MealType) -> some View {
            Button(action: {
//                foodViewModel.frequentFoods = []
                self.mealTypes = mealType
                print("mealTypes \(mealTypes)")
                print(" self.mealTypes.value \( self.mealTypes.value)")
                foodViewModel.fetchDefaultFoodData(mealType: self.mealTypes.value) {
                    print("viewModel.frequentFoods2 \(foodViewModel.frequentFoods.count)")
                    isActive = true
                }
            }) {
                MealCarouselItemView(mealType: mealType, userGoals: userGoals)
        }
    }
}


struct MealCarouselItemView: View {
    var mealType: MealType
    var userGoals: UserGoals
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(mealType.title)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 15)
                .padding(.top, 65)
            
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Spacer()
                switch mealType {
                case .breakfast:
                    Text("\(String(describing:Int( userGoals.totalBreakfastCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                case .lunch:
                    Text("\(String(describing:Int( userGoals.totalLunchCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                case .dinner:
                    Text("\(String(describing:Int( userGoals.totalDinnerCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                case .snacks:
                    Text("\(String(describing:Int( userGoals.totalSnacksCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                Text(" kcal")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .frame(height: 30)
            Image(uiImage: #imageLiteral(resourceName: "add-maeal-button"))
                .offset(y: 7)
            
            //
        }
        .frame(width: 110, height: 160, alignment: .leading)
        .background(RoundedCorners(tl: 8, tr: 100, bl: 8, br: 8).fill(LinearGradient(gradient: Gradient(colors: getGradientColors()), startPoint: .topLeading, endPoint: .bottomTrailing)))
        .shadow(color: getGradientColors()[1].opacity(0.8), radius: 20, x: 4, y: 12)
        .overlay(getTopIcon().offset(x: -21, y: -75))
        .padding(.top, 30)
    }
    
    private func getTopIcon() -> Image{
        switch mealType {
        case .breakfast:
            return Image(uiImage: #imageLiteral(resourceName: "breakfast-icon"))
        case .lunch:
            return Image(uiImage: #imageLiteral(resourceName: "Lunch-icon"))
            
        case .dinner:
            return Image(uiImage: #imageLiteral(resourceName: "Diner-icon"))
            
        case .snacks:
            return Image(uiImage: #imageLiteral(resourceName: "Snack-icon"))
        }
        
    }
    
    
    private func getGradientColors() -> [Color]{
        
        var colorTop: Color
        var colorBottom: Color
        
        switch mealType {
        case .breakfast:
            colorTop = Color(#colorLiteral(red: 0.9960784314, green: 0.7058823529, blue: 0.5921568627, alpha: 1))
            colorBottom = Color(#colorLiteral(red: 0.9764705882, green: 0.4235294118, blue: 0.4862745098, alpha: 1))
        case .lunch:
            colorTop = Color(#colorLiteral(red: 0.4901960784, green: 0.6, blue: 0.9254901961, alpha: 1))
            colorBottom = Color(#colorLiteral(red: 0.3529411765, green: 0.3647058824, blue: 0.8666666667, alpha: 1))
            
        case .dinner:
            colorTop = Color(#colorLiteral(red: 0.5333333333, green: 0.5529411765, blue: 0.9137254902, alpha: 1))
            colorBottom = Color(#colorLiteral(red: 0.1019607843, green: 0.05098039216, blue: 0.3647058824, alpha: 1))
            
        case .snacks:
            colorTop = Color(#colorLiteral(red: 1, green: 0.6745098039, blue: 0.7764705882, alpha: 1))
            colorBottom = Color(#colorLiteral(red: 1, green: 0.2862745098, blue: 0.5058823529, alpha: 1))
        }
        return [colorTop, colorBottom]
    }
    
}


//    }
//}






#Preview {
    DashBoardView()
}

