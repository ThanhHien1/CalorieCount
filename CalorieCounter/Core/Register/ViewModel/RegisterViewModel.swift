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
    @Published var errorMessage = ""
    @Published var emailError = ""
    @Published var registrationSuccessful: Bool = false

    func registerAccount() {
        guard FormValidator.isValid(email: email, password: password) else {
            errorMessage = "Please enter complete information"
            return
        }
        guard FormValidator.isValid(email: email, password: password) else {
            errorMessage = "Email invalidate"
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                UserDefaults.saveEmailAngPassword(email: self.email, password: self.password)
                self.registrationSuccessful = true
            }
        }
    }
}
