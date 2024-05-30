//
//  Utilities.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 28/4/24.
//

import Foundation

class Utilities {
    
    static func formatDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM - HH:mm"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    static func formatDate(date: Date) -> String {
        let dateFormatter: DateFormatter
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "EEEE, dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    
}
