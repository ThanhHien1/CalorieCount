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
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 60)
            Image("ic_logo")
                .resizable()
                .scaledToFit()
                .frame(width:Vconst.DESIGN_WIDTH_RATIO * 80)
            ErrorText
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 20)
            TextFieldEmail
            TextFieldPassword
            TextFieldConFirmPassword
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
            .multilineTextAlignment(.center)
    }
    
    var TextFieldEmail: some View {
        NormalTextField(title: "Nhập email", text: $viewModel.email, isPasswword: false, focusFieldType: .email)
    }
    
    var TextFieldPassword: some View {
        NormalTextField(title: "Nhập mật khẩu", text: $viewModel.password, isSecure: true, isPasswword: true, focusFieldType: .password)
    }
    
    var TextFieldConFirmPassword: some View {
        NormalTextField(title: "Xác nhận mật khẩu", text: $viewModel.confirmPassword, isSecure: true, isPasswword: true, focusFieldType: .password)
    }
    
    var ButtonRegister: some View {
        NavigationLink(destination: GoalView(), isActive: $viewModel.registrationSuccessful) {
            NormalButton(action: {
                viewModel.registerAccount()
            }, title: "Đăng kí" , tinColor: .white, color: Color.cl_F24F1D()
            )
        }
    }
    
    var ClicktoLogin: some View {
        HStack {
            Text("Bạn đã có tài khoản?")
                .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15))
                .foregroundStyle(.gray)
            NavigationLink{
                LoginView()
            } label: {
                Text("Đăng nhập")
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
