//
//  DashBoardView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation
import SwiftUI

struct DashBoardView: View {
    @ObservedObject var foodViewModel = FoodViewModel.instance
    @State var mealTypes: MealType = .breakfast
    @State var isActive: Bool = false
    @State var isShow: Bool = false
    @State var isShowSetting: Bool = false
    @State var breakFirst: [FoodToday] = []
    @State var lunch: [FoodToday] = []
    @State var dinner: [FoodToday] = []
    @State var snack: [FoodToday] = []
    let userGoals = UserGoals.instance
    let dailySummaryData = DailySummaryData.instance
    
    var body: some View {
        NavigationStack {
            LoadingView(isShowing: .constant(isShow)) {
                ScrollView {
                    VStack(spacing: 0) {
                        Header
                        CaloriesEatenAndBurnedView()
                        Nutritient_Card()
                        Spacer()
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Món ăn hôm nay")
                                .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 25)
                                .padding(.top, Vconst.DESIGN_WIDTH_RATIO * 10)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Vconst.DESIGN_WIDTH_RATIO * 20) {
                                    ForEach(MealType.allCases, id: \.self) { mealType in
                                        carouselItem(mealType: mealType)
                                            .padding(.bottom, Vconst.DESIGN_WIDTH_RATIO * 20)
                                    }
                                }
                                .background(NavigationLink("", destination: AddMealView(mealType: mealTypes), isActive: $isActive).hidden())
                                
                                .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO * 30)
                            }
                        }
                        Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 40)
                        VStack {
                            ItemFood
                        }
                        .padding(.bottom, Vconst.DESIGN_HEIGHT_RATIO * 50)
                    }
                    .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 20)
                }
            }
            .background(
                LinearGradient(colors: [Color.white.opacity(0.7), Color.orange.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), ignoresSafeAreaEdges: [.top, .leading, .trailing])
            .navigationBarBackButtonHidden()
            .onAppear {
                print("userGoals.foodToday \(userGoals.foodToday.count)")
                userGoals.fetchFoodToday() {_ in
                    updateMealArrays()
                }
                userGoals.fetchUserData() {_ in
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func updateMealArrays() {
        breakFirst = userGoals.foodToday.filter { $0.type == "Bữa sáng" }
        lunch = userGoals.foodToday.filter { $0.type == "Bữa trưa" }
        dinner = userGoals.foodToday.filter { $0.type == "Bữa tối" }
        snack = userGoals.foodToday.filter { $0.type == "Bữa phụ" }
        self.dailySummaryData.updateRemainingCalories()
    }
    
    var Header: some View {
        HStack {
            Spacer()
            Text("Calories")
                .font(.system(size: 24))
                .foregroundStyle(.orange)
            Spacer()
            NavigationLink(destination: ProfileView(), isActive: $isShowSetting, label: {
                Button(action: {
                    isShowSetting = true
                }, label: {
                    Image(systemName: "person").badge(2)
                        .foregroundColor(.black)
                        .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 20)
                })
            })
        }
    }
    
    private func carouselItem(mealType: MealType) -> some View {
        Button(action: {
            self.mealTypes = mealType
            isShow = true
            foodViewModel.getAllFood(mealType: self.mealTypes.value) {
                isActive = true
                isShow = false
            }
        }) {
            MealCarouselItemView(mealType: mealType, userGoals: userGoals)
        }
    }
    
    var ItemFood: some View {
        Group {
            if !breakFirst.isEmpty {
                VStack {
                    Text("Buổi sáng")
                    ForEach(breakFirst, id: \.self) { foodToday in
                        ItemRowFood(foods: foodToday.foods[0]) {
                            userGoals.deleteFood(foodToDelete: foodToday) {_ in 
                                updateMealArrays()
                            }
                        }
                    }
                }
            }
            if !lunch.isEmpty {
                VStack {
                    Text("Buổi trưa")
                    ForEach(lunch, id: \.self) { foodToday in
                        ItemRowFood(foods: foodToday.foods[0]) {
                            userGoals.deleteFood(foodToDelete: foodToday) {_ in
                                updateMealArrays()
                            }
                        }
                    }
                }
            }
            if !dinner.isEmpty {
                VStack {
                    Text("Buổi tối")
                    ForEach(dinner, id: \.self) { foodToday in
                        ItemRowFood(foods: foodToday.foods[0]) {
                            userGoals.deleteFood(foodToDelete: foodToday) {_ in
                                updateMealArrays()
                            }
                        }
                    }
                }
            }
            if !snack.isEmpty {
                VStack {
                    Text("Ăn vặt")
                    ForEach(snack, id: \.self) { foodToday in
                        ItemRowFood(foods: foodToday.foods[0]) {
                            userGoals.deleteFood(foodToDelete: foodToday) {_ in
                                updateMealArrays()
                            }
                        }
                    }
                }
            }
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
                    Text("\(String(describing: Int(userGoals.totalBreakfastCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                case .lunch:
                    Text("\(String(describing: Int(userGoals.totalLunchCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                case .dinner:
                    Text("\(String(describing: Int(userGoals.totalDinnerCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                case .snacks:
                    Text("\(String(describing: Int(userGoals.totalSnacksCal ?? 0)))")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                Text(" kcal")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .frame(height: Vconst.DESIGN_HEIGHT_RATIO * 30)
            Image(uiImage: #imageLiteral(resourceName: "add-maeal-button"))
                .offset(y: 7)
        }
        .frame(width: Vconst.DESIGN_WIDTH_RATIO * 110, height: Vconst.DESIGN_HEIGHT_RATIO * 160, alignment: .leading)
        .background(RoundedCorners(tl: 8, tr: 100, bl: 8, br: 8).fill(LinearGradient(gradient: Gradient(colors: getGradientColors()), startPoint: .topLeading, endPoint: .bottomTrailing)))
        .shadow(color: getGradientColors()[1].opacity(0.8), radius: 20, x: 4, y: 12)
        .overlay(getTopIcon().offset(x: -21, y: -75))
        .padding(.top, 30)
    }
    
    private func getTopIcon() -> Image {
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



#Preview {
    DashBoardView()
}

