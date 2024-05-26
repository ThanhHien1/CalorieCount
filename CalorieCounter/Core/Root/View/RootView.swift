//
//  RootView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel = RootViewModel()
    @ObservedObject var userGoals = UserGoals.instance
    @ObservedObject var foodViewModel = FoodViewModel.instance
    @State var isLoadingSpash: Bool = true
    
    var body: some View {
        ZStack {
            NavigationStack {
                if isLoadingSpash {
                    SplashView()
                } else if viewModel.isLogin() {
//                   GoalView()
//                    DashBoardView()
                    TabBarView()
                } else {
                  RegisterView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConfiguration.shared.timeEnableSplash) {
                self.isLoadingSpash = false
            }
            userGoals.fetchUserData() {_ in
            }
            userGoals.fetchFoodToday() { _,_  in
            }
//            foodViewModel.getAllFood() {
//                print("####foodViewModel.foods \(foodViewModel.foods)")
//            }
        }
    }
}

#Preview {
    RootView()
}
