//
//  NormalButton.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct NormalButton: View {
    let action: (() -> Void)
    var title: String = "Register"
    var tinColor: Color = .white
    var color: Color = .blue
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(tinColor)
                .frame(width: Vconst.DESIGN_WIDTH_RATIO * 300)
                .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 18)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: Vconst.DESIGN_WIDTH_RATIO * 30))
            
                
        })
    }
}

#Preview {
    NormalButton(action: {})
}
