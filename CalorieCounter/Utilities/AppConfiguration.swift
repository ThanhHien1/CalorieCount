//
//  AppConfiguration.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import Foundation
import UIKit

final class AppConfiguration {
    
    static let shared = AppConfiguration()
    
    let timeEnableSplash: CGFloat = 2.0
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
