//
//  UserDefault.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import Foundation

extension UserDefaults {
    
    static func saveEmailAngPassword(email:  String, password: String) {
        let combinedString = "\(email)|\(password)"
        UserDefaults.standard.set(combinedString, forKey: Constanst.registeredUserKey)
    }
    
    static func getEmailAndPassword() -> (email: String, password: String)? {
        if let combinedString = UserDefaults.standard.string(forKey: Constanst.registeredUserKey) {
            let components = combinedString.components(separatedBy: "|")
            if components.count == 2 {
                let email = components[0]
                let password = components[1]
                return (email, password)
            }
        }
        return nil
    }
}
