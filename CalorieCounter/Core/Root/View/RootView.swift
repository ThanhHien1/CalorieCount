//
//  RootView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel = RootViewModel()
    @State var isLoadingSpash: Bool = true
    
    var body: some View {
        ZStack {
            NavigationStack {
                if isLoadingSpash {
                    SplashView()
                } else if viewModel.isLogin() {
                   GoalView()
                } else {
                  RegisterView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConfiguration.shared.timeEnableSplash) {
                self.isLoadingSpash = false
            }
        }
    }
}

#Preview {
    RootView()
}
