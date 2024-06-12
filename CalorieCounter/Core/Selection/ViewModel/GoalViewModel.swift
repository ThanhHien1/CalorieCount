//
//  GoalViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class GoalViewModel: ObservableObject {
    @Published var goalType: GoalEnum = .main
    @Published var activeness: ActivenessEnum = .lightlyActive
    @Published var sex: GenderEnum = .male
    @Published var age: Int = 25
    @Published var height: Float = 1.70
    @Published var weight: Float = 100
    @Published var calorie: Int = 0
    @Published var caloriesConsumed: Int = 0
    @Published var bmi: Float = 1.70
    @Published var dateUpdate: String = ""
    @Published var foodToday: [FoodToday] = []
    static let instance = GoalViewModel()
    let db = Firestore.firestore()
    
    
    func saveDataUser(complete: @escaping() -> Void) {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let user = UserData(email: currentUserEmail, calorie: calorie, sex: sex.title, weight: weight, height: height, age: age, activeness: activeness.rawValue, bmh: activeness.bmh, bmi: bmi, changeCalorieAmount: goalType.changeCalorieAmount, goalType: goalType.name, date: dateUpdate, currentCarbs: 0, currentPro: 0, currentFat: 0, caloriesConsumed: caloriesConsumed)
            var dataToUpdate: [String: Any] = convertUserDataToDictionary(user: user)
            let userDocumentRef = db.collection("User").document("\(currentUserEmail)")
            userDocumentRef.setData(dataToUpdate, merge: true) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    complete()
                    print("Document successfully written!")
                }
            }
        }
    }
    
    func saveFoodToday(newFood: FoodToday, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No current user logged in")
            return
        }
        
        guard let jsonData = try? JSONEncoder().encode(newFood),
              let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            print("Error encoding or serializing food data")
            return
        }
        
        let documentRef = db.collection("foodToday").document(currentUserEmail)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var currentData = document.data(), var existingFoods = currentData["foods"] as? [[String: Any]] {
                    existingFoods.append(jsonObject)
                    documentRef.setData(["foods": existingFoods]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated!")
                            completion()
                        }
                    }
                } else {
                    print("Document data was empty or format was unexpected, creating new document with initial food data.")
                    documentRef.setData(["foods": [jsonObject]]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            completion()
                        }
                    }
                }
            } else {
                print("Document does not exist. Creating a new document.")
                documentRef.setData(["foods": [jsonObject]]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        completion()
                    }
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
            
            let userDocumentRef = db.collection("User").document(currentUserEmail)
            let dataToUpdate: [String: Any] = convertUserDataToDictionary(user: user)
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
            userData["email"] = user.email
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
            userData["date"] = dateUpdate
            userData["currentCarbs"] = user.currentCarbs
            userData["currentPro"] = user.currentPro
            userData["currentFat"] = user.currentFat
            userData["caloriesConsumed"] = user.caloriesConsumed
            return userData
        }
        
        func updateInfomation(user: UserData) {
            calorie = user.calorie
            height = user.height
            print("######## height \(height)")
            weight = user.weight
            age = user.age
            if user.sex == sex.rawValue.capitalized {
                sex = GenderEnum(rawValue: user.sex) ?? .male
            }
            if user.activeness  == activeness.title {
                activeness = ActivenessEnum(rawValue:  user.activeness) ?? .extraActive
            }
        }

        
        func logout() {
            do { 
                try Auth.auth().signOut() }
            catch { print("already logged out")
            }
        }
}
