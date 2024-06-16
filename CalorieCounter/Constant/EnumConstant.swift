//
//  EnumConstant.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 8/6/24.
//

import Foundation

enum GoalEnum: CaseIterable {
    case lose
    case main
    case gain
    
    init?(stringValue: String) {
        switch stringValue {
        case "lose":
            self = .lose
        case "main":
            self = .main
        case "gain":
            self = .gain
        default:
            return nil
        }
    }
        
        var name: String {
            switch self {
            case .lose:
                "lose"
            case .main:
                "main"
            case .gain:
                "gain"
            }
        }
        
        var title: String {
            switch self {
            case .lose:
                "🍏 Giảm cân"
            case .main:
                "🧘 Giữ cân"
            case .gain:
                "💪 Tăng cân"
            }
        }
        
        var changeCalorieAmount: Int {
            switch self {
            case .lose:
                -500
            case .main:
                0
            case .gain:
                500
            }
        }
    }
    
    enum ActivenessEnum: String, CaseIterable {
        case sedentary
        case lightlyActive
        case moderatelyActive
        case veryActive
        case extraActive
        
        var name: String {
            switch self {
            case .sedentary:
                return "Sedentary"
            case .lightlyActive:
                return "Lightly Active"
            case .moderatelyActive:
                return "Moderately Active"
            case .veryActive:
                return "Very Active"
            case .extraActive:
                return "Extra Active"
            }
        }
        
        var title: String {
            switch self {
            case .sedentary:
                return "🛋️ Rất ít"
            case .lightlyActive:
                return "🧑‍💻 Ít"
            case .moderatelyActive:
                return "🧑‍🏫 Trung bình"
            case .veryActive:
                return "🧑‍💼 Cao"
            case .extraActive:
                return "👷 Rất cao"
            }
        }
        
        var subTitle: String {
            switch self {
            case .sedentary:
                return "Hoạt động chủ yếu trong văn phòng, ít vận động."
            case .lightlyActive:
                return "Hoạt động nhẹ nhàng, đi bộ một ít."
            case .moderatelyActive:
                return "Hoạt động đi bộ vừa phải."
            case .veryActive:
                return "Hoạt động vận động cao, đòi hỏi sức khỏe và thể lực."
            case .extraActive:
                return "Hoạt động cực kỳ cao, yêu cầu sức khỏe và thể lực tối đa."
                
            }
        }
            
        var bmh: Float {
            switch self {
            case .sedentary:
                return 1.2
            case .lightlyActive:
                return 1.375
            case .moderatelyActive:
                return 1.55
            case .veryActive:
                return 1.725
            case .extraActive:
                return 1.9
            }
        }
    }
    
    enum GenderEnum: String, CaseIterable {
        case male
        case female
        
        var title: String {
            switch self {
            case .male:
                "Nam"
            case .female:
                "Nữ"
            }
        }
    }
    

enum MealType: Int, CaseIterable {
    case breakfast = 0
    case lunch = 1
    case dinner = 2
    case snacks = 3
    
    var value: Int {
        switch self {
        case .breakfast:
            0
        case .lunch:
            1
        case .dinner:
            2
        case .snacks:
            3
        }
    }
    
    var title: String {
        switch self {
        case .breakfast:
            "Bữa sáng"
        case .lunch:
            "Bữa trưa"
        case .dinner:
            "Bữa tối"
        case .snacks:
            "Bữa phụ"
        }
    }
    
    var idFirebase: String {
        switch self {
        case .breakfast:
            "breakfast"
        case .lunch:
            "lunch"
        case .dinner:
            "dinner"
        case .snacks:
            "snacks"
        }
    }
    
}
