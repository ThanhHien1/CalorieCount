//
//  NormalTextField.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct NormalTextField: View {
    let title: String
    let color: Color
    let imageURL: String
    @State var text: String
    @FocusState var isFocused: Bool
    var onTextChange: ((String) -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image("\(imageURL)")
                .resizable()
                .frame(width: 24, height: 24)
                .padding([.leading,.trailing], 12)
            TextField("Enter \(title.lowercased())", text: $text)
                .padding(.leading, 50)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? color : Color.cl_E1E2E7(), lineWidth: 1)
                )
                .autocapitalization(UITextAutocapitalizationType.none)
                .focused($isFocused)
                .padding(.top, 2)
                .onChange(of: text) { newValue in
                    onTextChange?(newValue)
                }
        }
        .padding(.top, 10)
        .padding(.horizontal, 30)
    }
}

#Preview {
    NormalTextField(title: "Name", color: .white, imageURL: "person", text: "")
}
