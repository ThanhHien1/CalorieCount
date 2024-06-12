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
//        historyModel.saveFood()
//        let dateStrings = ["25/06/2024", "26/06/2024", "27/06/2024", "28/06/2024", "29/06/2024", "30/06/2024"]
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        let dateString = "25/06/2024"
//        for dateString in dateStrings {
//            if let date = dateFormatter.date(from: dateString) {
//                let timestamp = date.timeIntervalSince1970
//                print(timestamp)
//            } else {
//                print("Invalid date string")
//            }
//        }

        let dateString = "25/5/2024"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        if let date = dateFormatter.date(from: dateString) {
            let unixTime = date.timeIntervalSince1970
            print(unixTime)
        } else {
            print("Không thể chuyển đổi ngày")
        }


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
