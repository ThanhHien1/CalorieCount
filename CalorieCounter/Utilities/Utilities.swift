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

}
