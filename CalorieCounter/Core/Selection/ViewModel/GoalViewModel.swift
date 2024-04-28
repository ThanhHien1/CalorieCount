//
//  GoalViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum GoalEnum: CaseIterable {
    case lose
    case main
    case gain
    
    
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
            "🍏 Lose Weight"
        case .main:
            "🧘 Maintain Weight"
        case .gain:
            "💪 Gain Muscle"
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

enum ActivenessEnum: CaseIterable {
    case sedentary
    case lightlyActive
    case moderatelyActive
    case veryActive
    case extraActive
    
    var title: String {
        switch self {
        case .sedentary:
            return "🛋️ Sedentary"
        case .lightlyActive:
            return "🧑‍💻 Lightly Active"
        case .moderatelyActive:
            return "🧑‍🏫 Moderately Active"
        case .veryActive:
            return "🧑‍💼 Very Active"
        case .extraActive:
            return "👷 Extra Active"
        }
    }
    
    var subTitle: String {
        switch self {
        case .sedentary:
            return "Mostly sitting. e.g. office worker"
        case .lightlyActive:
            return "Some walking. e.g. student"
        case .moderatelyActive:
            return "Moderate walking. e.g. office worker"
        case .veryActive:
            return "Physically demanding. e.g. builder"
        case .extraActive:
            return "Extremely physically demanding. e.g. athlete"
        }
    }
    
    var bmh: Float {
        switch self {
        case .sedentary:
            return 1.2
        case .lightlyActive:
            return 1.375
        case .moderatelyActive:
            return 1.5
        case .veryActive:
            return 1.725
        case .extraActive:
            return 1.9
        }
    }
}

enum GenderEnum: CaseIterable {
    case male
    case female
    
    var title: String {
        switch self {
        case .male:
            "Male"
        case .female:
            "Female"
        }
    }
}

class GoalViewModel: ObservableObject {
    @Published var goalType: GoalEnum = .main
    @Published var activeness: ActivenessEnum = .lightlyActive
    @Published var sex: GenderEnum = .male
    @Published var age: Float = 25
    @Published var height: Float = 1.70
    @Published var weight: Float = 100
    @Published var calorie: Int = 0
    @Published var dateUpdate: String = ""
    static let instance = GoalViewModel()
    let db = Firestore.firestore()
    
    func saveDataUser() {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            db.collection("UserInformations").document("\(currentUserEmail)").setData([
                "UserEmail": currentUserEmail,
                "calorie": calorie,
                "sex": sex.title,
                "weight": weight,
                "height": height * 100,
                "age": age,
                "bmh": activeness.bmh,
                "changeCalorieAmount": goalType.changeCalorieAmount,
                "goalType": goalType.name,
                "currentDay": dateUpdate,
                "currentCarbs": 0.0,
                "currentPro": 0.0,
                "currentFat": 0.0,
                "currentBreakfastCal": 0,
                "currentLunchCal": 0,
                "currentDinnerCal": 0,
                "currentSnacksCal": 0,
                "currentBurnedCal": 0,
                "weeklyGoal": 0,
                "calorieGoal": 0,
                "adviced": true,
                "goalWeight": 0.0,
                "dietaryType": "Classic"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    
    func fetchUserData(completion: @escaping (Result<UserData, Error>) -> Void) {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            db.collection("UserInformations").document(currentUserEmail).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = document, document.exists else {
                    let documentNotFoundError = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                    completion(.failure(documentNotFoundError))
                    return
                }
                
                do {
                    guard let userData = document.data() else {
                        let dataParsingError = NSError(domain: "Firestore", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to parse document data"])
                        completion(.failure(dataParsingError))
                        return
                    }
                    
                    let userEmail = currentUserEmail
                    let calorie = userData["calorie"] as? Int ?? 0
                    let sex = userData["sex"] as? String ?? ""
                    let weight = userData["weight"] as? Float ?? 0.0
                    let height = userData["height"] as? Float ?? 0.0
                    let age = userData["age"] as? Int ?? 0
                    let bmh = userData["bmh"] as? Float ?? 0.0
                    let changeCalorieAmount = userData["changeCalorieAmount"] as? Int ?? 0
                    let goalType = userData["goalType"] as? String ?? ""
                    let currentDay = userData["currentDay"] as? Date ?? Date()
                    let currentCarbs = userData["currentCarbs"]  as? Int ?? 0
                    let currentPro = userData["currentPro"] as? Int ?? 0
                    let currentFat = userData["currentFat"]  as? Int ?? 0
                    let currentBreakfastCal = userData["currentBreakfastCal"]  as? Int ?? 0
                    let currentLunchCal = userData["currentLunchCal"]  as? Int ?? 0
                    let currentDinnerCal = userData["currentDinnerCal"] as? Int ?? 0
                    let currentSnacksCal = userData["currentSnacksCal"] as? Int ?? 0
                    let currentBurnedCal = userData["currentBurnedCal"] as? Int ?? 0
                    let weeklyGoal = userData["weeklyGoal"] as? Int ?? 0
                    let calorieGoal = userData["calorieGoal"] as? Int ?? 0
                    let adviced = userData["adviced"] as? Bool ?? true
                    let goalWeight = userData["goalWeight"]  as? Int ?? 0
                    let dietaryType  = userData["dietaryType"] as? String ?? ""
                    
                    let user = UserData(userEmail: userEmail, calorie: calorie, sex: sex, weight: weight, height: height, age: age, bmh: bmh, changeCalorieAmount: changeCalorieAmount, goalType: goalType, currentDay: currentDay, currentCarbs: currentCarbs, currentPro: currentPro, currentFat: currentFat, currentBreakfastCal: currentBreakfastCal, currentLunchCal: currentLunchCal, currentDinnerCal: currentDinnerCal, currentSnacksCal: currentSnacksCal, currentBurnedCal: currentBurnedCal, weeklyGoal: weeklyGoal, calorieGoal: calorieGoal, adviced: adviced, goalWeight: goalWeight, dietaryType: dietaryType)
                    
                    completion(.success(user))
                } catch let parsingError {
                    completion(.failure(parsingError))
                }
            }
        }
    }
    
}
