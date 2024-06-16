//
//  DateManager.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 28/5/24.
//

import Foundation

import Foundation

class DateManager {
    
    static let shared = DateManager()
    
    private let lastCheckedDateKey = "lastCheckedDate"
    
    private init() {}
    func saveCurrentDate() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: lastCheckedDateKey)
    }
    
    func getLastCheckedDate() -> Date? {
        return UserDefaults.standard.object(forKey: lastCheckedDateKey) as? Date
    }
    
    func isNewDay() -> Bool {
        guard let lastCheckedDate = getLastCheckedDate() else {
            return true
        }
        
        let calendar = Calendar.current
        let lastDate = calendar.startOfDay(for: lastCheckedDate)
        let currentDate = calendar.startOfDay(for: Date())
        return lastDate != currentDate
    }
    
    func getCurrentDayDDMMYYYY() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
    }

}
