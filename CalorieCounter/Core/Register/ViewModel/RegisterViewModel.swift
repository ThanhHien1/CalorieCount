//
//  RegisterViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage = ""
    @Published var emailError = ""
    @Published var registrationSuccessful: Bool = false

    func registerAccount() {
        guard FormValidator.isValid(email: email, password: password) else {
            errorMessage = "Vui lòng nhập thông tin đầy đủ"
            return
        }
        guard FormValidator.isValid(email: email, password: password) else {
            errorMessage = "Email không đúng định dạng"
            return
        }
        
        guard FormValidator.confirmPassword(confirmPassword: confirmPassword, password: password) else {
            errorMessage = "Mật khẩu không trùng khớp"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = "Email đã tồn tại"
            } else {
                UserDefaults.saveEmailAngPassword(email: self.email, password: self.password)
                self.registrationSuccessful = true
            }
        }
    }
}
