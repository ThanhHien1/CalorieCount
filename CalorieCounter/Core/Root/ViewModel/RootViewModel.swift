//
//  RootViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

class RootViewModel: ObservableObject {
    
    func isLogin() -> Bool {
        guard let email = UserDefaults.getEmailAndPassword()?.email else { return false }
        if !email.isEmpty && Auth.auth().currentUser != nil {
            return true
        }
        return false
    }
}
