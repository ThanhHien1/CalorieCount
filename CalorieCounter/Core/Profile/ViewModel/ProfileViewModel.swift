//
//  ProfileViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 12/5/24.
//

import Foundation

enum ProfileEnum: CaseIterable {
    case calories
    case height
    case weight
    case age
    case gender
    case activeness
    
    var title: String {
        switch self {
        case .calories:
            "KCal/day"
        case .height:
            "Height"
        case .weight:
            "Weight"
        case .age:
            "Age"
        case .gender:
            "Gender"
        case .activeness:
            "Exercise intensity"
        }
    }
    
//    var destination:  {
//        switch self {
//        case .calories:
//            <#code#>
//        case .height:
//            <#code#>
//        case .weight:
//            <#code#>
//        case .age:
//            <#code#>
//        case .gender:
//            <#code#>
//        case .activeness:
//            <#code#>
//        }
//    }
}

class ProfileViewModel: ObservableObject {
    @Published var calories: Int = 0
    @Published var height: Float = 0
    @Published var weight: Int = 0
    @Published var age: Int = 0
    @Published var gender: GenderEnum = .female
    @Published var activeness: ActivenessEnum = .extraActive
    
}
