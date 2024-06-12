//
//  SettingViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 22/5/24.
//

import Foundation

enum SettingEnum: CaseIterable {
    case update
    case logout
    
    var title: String {
        switch self {
        case .update:
            "Cập nhật BMR "
        case .logout:
            "Đăng xuất"
        }
    }
}
    
