//
//  RegisterViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()
    @FocusState var focusedField: FocusField?
    
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 100)
            Image("ic_logo")
                .resizable()
                .scaledToFit()
                .frame(width:Vconst.DESIGN_WIDTH_RATIO * 80)
            ErrorText
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 30)
            TextFieldEmail
            TextFieldPassword
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 50)
            ButtonRegister
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 100)
            ClicktoLogin
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

extension RegisterView {
    
    var ErrorText: some View {
        Text(viewModel.errorMessage)
            .font(.system(size: 13))
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 20)
            .foregroundColor(.red)
            .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO * 30)
    }
    
    var TextFieldEmail: some View {
        NormalTextField(title: "Enter your email", text: $viewModel.email, focusFieldType: .email)
    }
    
    var TextFieldPassword: some View {
        NormalTextField(title: "Enter your password", text: $viewModel.password, isPassword: true, focusFieldType: .password)
    }
    
    var ButtonRegister: some View {
        NavigationLink(destination: GoalView(), isActive: $viewModel.registrationSuccessful) {
            NormalButton(action: {
                viewModel.registerAccount()
            }, title: "Register" , tinColor: .white, color: Color.cl_F24F1D()
            )
        }
    }
    
    var ClicktoLogin: some View {
        HStack {
            Text("Don't have account?")
                .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15))
                .foregroundStyle(.gray)
            NavigationLink{
                LoginView()
            } label: {
                Text("Click here to login")
                    .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15))
                    .foregroundStyle(Color.blue)
                    .underline()
            }
        }
    }
}

#Preview {
    RegisterView()
}
