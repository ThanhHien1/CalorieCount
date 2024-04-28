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
            Color.cl_F24F1D().opacity(0.3)
                .ignoresSafeArea()
            Image("ic_splash")
                .resizable()
                .scaledToFit()
                .frame(width: Vconst.DESIGN_WIDTH_RATIO * 300)
        }
    }
}

#Preview {
    SplashView()
}
