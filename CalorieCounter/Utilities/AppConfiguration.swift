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

struct NavigationUtil {
    static func popToRootView() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            findNavigationController(viewController: UIApplication.shared.windows.filter { $0.isKeyWindow}.first?.rootViewController)?
                .popToRootViewController(animated: true)
        }
    }
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        if let navigationController = viewController as? UINavigationController{
            return navigationController
        }
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        return nil
    }
}
