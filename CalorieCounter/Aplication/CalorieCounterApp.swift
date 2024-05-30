//
//  CalorieCounterApp.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestoreInternal

class AppDelegate: NSObject, UIApplicationDelegate {
    let historyModel = HistoryModel()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        historyModel.saveFood()
        return true
    }
}

@main
struct CalorieCounterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
