//
//  RootViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import Foundation

class RootViewModel: ObservableObject {
    
    func isLogin() -> Bool {
        guard let email = UserDefaults.getEmailAndPassword()?.email else { return false }
        if !email.isEmpty {
            return true
        }
        return false
    }
}
