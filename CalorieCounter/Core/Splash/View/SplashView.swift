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
