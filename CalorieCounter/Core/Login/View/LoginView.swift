//
//  LoginView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
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
            ButtonLogin
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 100)
            ClicktoRegister
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

extension LoginView {
    
    var ErrorText: some View {
        Text(viewModel.errorMessage)
            .font(.system(size: 13))
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 20)
            .foregroundColor(.red)
            .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO * 30)
    }
    
    var TextFieldEmail: some View {
        NormalTextField(title: "Nhập email", text: $viewModel.email, isPasswword: false, focusFieldType: .email)
    }
    
    var TextFieldPassword: some View {
        NormalTextField(title: "Nhập mật khẩu", text: $viewModel.password, isSecure: true, isPasswword: true, focusFieldType: .password)
    }
    
    var ButtonLogin: some View {
        NavigationLink(destination: TabBarView(), isActive: $viewModel.loginSuccessful) {
            NormalButton(action: {
                viewModel.loginAccount()
            }, title: "Đăng nhập" , tinColor: .white, color: Color.cl_F24F1D()
            )
        }
    }
    
    var ClicktoRegister: some View {
        HStack {
            Text("Bạn chưa có tài khoản")
                .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15))
                .foregroundStyle(.gray)
            NavigationLink{
              RegisterView()
            } label: {
                Text("Đăng kí")
                    .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15))
                    .foregroundStyle(Color.blue)
                    .underline()
            }
        }
    }
}
#Preview {
    LoginView()
}
