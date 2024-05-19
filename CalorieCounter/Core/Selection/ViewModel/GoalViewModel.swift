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
    
    enum ActivenessEnum: String, CaseIterable {
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
    
    enum GenderEnum: String, CaseIterable {
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
        @Published var age: Int = 25
        @Published var height: Float = 1.70
        @Published var weight: Float = 100
        @Published var calorie: Int = 0
        @Published var bmi: Float = 1.70
        @Published var dateUpdate: String = ""
        static let instance = GoalViewModel()
        let db = Firestore.firestore()
        
        func saveDataUser(complete: @escaping() -> Void) {
            if let currentUserEmail = Auth.auth().currentUser?.email {
                let user = UserData(userEmail: currentUserEmail, calorie: calorie, sex: sex.title, weight: weight, height: height, age: age, activeness: activeness.rawValue, bmh: activeness.bmh, bmi: bmi, changeCalorieAmount: goalType.changeCalorieAmount, goalType: goalType.name, currentDay: dateUpdate, currentCarbs: 0, currentPro: 0, currentFat: 0, currentBreakfastCal: 0, currentLunchCal: 0, currentDinnerCal: 0, currentSnacksCal: 0, currentBurnedCal: 0, weeklyGoal: 0, calorieGoal: calorie, adviced: true, goalWeight: 0, dietaryType: "Classic")
                print("#########\(user)")
                var dataToUpdate: [String: Any] = convertUserDataToDictionary(user: user)
                db.collection("UserInformations").document("\(currentUserEmail)").setData(dataToUpdate) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        complete()
                        print("Document successfully written!")
                    }
                }
            }
        }
        
        func updateUserData(user: UserData, completion: @escaping () -> Void) {
            guard let currentUserEmail = Auth.auth().currentUser?.email else {
                print("Current user email is nil")
                return
            }
            print("currentUserEmail \(currentUserEmail)")
            
            let userDocumentRef = db.collection("UserInformations").document(currentUserEmail)
            var dataToUpdate: [String: Any] = convertUserDataToDictionary(user: user)
            userDocumentRef.updateData(dataToUpdate) { error in
                   if let error = error {
                       print("Error updating user data: \(error)")
                   } else {
                       completion()
                       print("User data updated successfully")
                   }
               }
        }
        
        
        func convertUserDataToDictionary(user: UserData) -> [String: Any] {
            var userData: [String: Any] = [:]
            
            userData["UserEmail"] = user.userEmail
            userData["calorie"] = user.calorie
            userData["sex"] = user.sex
            userData["weight"] = user.weight
            userData["height"] = user.height
            userData["age"] = user.age
            userData["activeness"] = user.activeness
            userData["bmh"] = user.bmh
            userData["bmi"] = user.bmi
            userData["changeCalorieAmount"] = user.changeCalorieAmount
            userData["goalType"] = user.goalType
            userData["currentDay"] = dateUpdate
            userData["currentCarbs"] = user.currentCarbs
            userData["currentPro"] = user.currentPro
            userData["currentFat"] = user.currentFat
            userData["currentBreakfastCal"] = user.currentBreakfastCal
            userData["currentLunchCal"] = user.currentLunchCal
            userData["currentDinnerCal"] = user.currentDinnerCal
            userData["currentSnacksCal"] = user.currentSnacksCal
            userData["currentBurnedCal"] = user.currentBurnedCal
            userData["weeklyGoal"] = user.weeklyGoal
            userData["calorieGoal"] = user.calorieGoal
            userData["adviced"] = user.adviced
            userData["goalWeight"] = user.goalWeight
            userData["dietaryType"] = user.dietaryType
            
            return userData
        }
}
