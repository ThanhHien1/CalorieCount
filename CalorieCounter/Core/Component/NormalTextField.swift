//
//  NormalTextField.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct NormalTextField: View {
    var title: String
    @Binding var text:String
    @State private var strokeColor:Color = Color.cl_E1E2E7()
    var isPassword: Bool = false
    @FocusState var focusedField: FocusField?
    var focusFieldType: FocusField
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: Vconst.DESIGN_HEIGHT_RATIO * 2.0) {
                CustomTextField(title: title, text: $text, textContentType: .emailAddress, keyboardType: .emailAddress, focusedField: $focusedField, focusFieldType: .password, strokeColor: $strokeColor)
                    .onChange(of: focusedField) { newValue in
                        if newValue == .password {
                            strokeColor = Color.cl_F24F1D()
                        } else {
                            strokeColor = Color.cl_E1E2E7()
                        }
                    }
                    .onChange(of: text) { newValue in
                        
                    }
                
            }
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
            .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO * 30)
        }
    }
}

#Preview {
    NormalTextField(title: "Enter your password", text: .constant("password"), focusFieldType: .password)
}
