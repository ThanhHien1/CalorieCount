//
//  LoginView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 100)
            Image("ic_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
            NormalTextField(title: "Name", color: .white, imageURL: "person", text: <#T##String#>)
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
