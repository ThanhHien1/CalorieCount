//
//  BackButton.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 18/5/24.
//

import SwiftUI

struct BackButton: View {
    var color: Color = .white
    var onBack: (() -> Void)?
    var body: some View {
        VStack {
            Button(action: {
                onBack?()
            }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .foregroundColor(color)
            }
            
            .frame(width: Vconst.DESIGN_WIDTH_RATIO * 20, height: Vconst.DESIGN_HEIGHT_RATIO * 20)
        }
    }
}

#Preview {
    BackButton()
}
