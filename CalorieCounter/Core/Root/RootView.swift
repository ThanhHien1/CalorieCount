//
//  RootView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct RootView: View {
    @State var isLoadingSpash: Bool = true
    var body: some View {
        ZStack {
            NavigationStack {
                if isLoadingSpash {
                    SplashView()
                }
            }
        }
    }
}

#Preview {
    RootView()
}
