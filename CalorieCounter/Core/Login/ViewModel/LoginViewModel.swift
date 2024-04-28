//
//  LoginViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage = ""
    @Published var emailError = ""
    @Published var loginSuccessful: Bool = false
    
    func loginAccount() {
        guard FormValidator.isValid(email: email, password: password) else {
            errorMessage = "Please enter complete information"
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                UserDefaults.saveEmailAngPassword(email: self.email, password: self.password)
                self.loginSuccessful = true
            }
        }
    }
}
