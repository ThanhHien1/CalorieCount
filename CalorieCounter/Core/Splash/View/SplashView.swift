//
//  SplashView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.cl_30D6D7()
                .ignoresSafeArea()
            Image("ic_splash")
                .resizable()
                .scaledToFit()
                .frame(width: 350)
        }
    }
}

#Preview {
    SplashView()
}
