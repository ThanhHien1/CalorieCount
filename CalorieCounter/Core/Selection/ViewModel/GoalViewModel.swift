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
    @Published var sex: GenderEnum = .female
    @Published var age: Int = 25
    @Published var height: Float = 1.70
    @Published var weight: Float = 100
    @Published var calorie: Int = 0
    @Published var caloriesConsumed: Int = 0
    @Published var bmi: Float = 1.70
    @Published var dateUpdate: String = ""
    static let instance = GoalViewModel()
    let db = Firestore.firestore()
    
    
    func saveDataUser(complete: @escaping() -> Void) {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            let user = UserData(email: currentUserEmail, calorie: calorie, sex: sex.title, weight: weight, height: height, age: age, activeness: activeness.rawValue, bmh: activeness.bmh, bmi: bmi, changeCalorieAmount: goalType.changeCalorieAmount, goalType: goalType.name, date: dateUpdate, currentCarbs: 0, currentPro: 0, currentFat: 0, caloriesConsumed: caloriesConsumed)
            let dataToUpdate: [String: Any] = convertUserDataToDictionary(user: user)
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
    
    func saveTagertCalories(email: String){
        let db = Firestore.firestore()
        let documentRef = db.collection("foodToday").document(email)
            .collection(DateManager.shared.getCurrentDayDDMMYYYY() + "-target").document("total")
        documentRef.setData(["total": UserGoals.instance.user?.calorie ?? 0.0], merge: true)
    }
    
    func getTagertCalories(day: String, completion: @escaping (Double) -> Void){
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No current user logged in")
            completion(0.0)
            return
        }
        
        let db = Firestore.firestore()
        let documentRef = db.collection("foodToday").document(currentUserEmail)
            .collection(day + "-target").document("total")
        documentRef.getDocument { snap, err in
            completion(snap?.data()?["total"] as? Double ?? 0.0)
        }
    }
    
    func saveFoodToday(newFood: FoodToday, completion: @escaping (Bool) -> Void) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No current user logged in")
            completion(false)
            return
        }
        
        let db = Firestore.firestore()
        let documentRef = db.collection("foodToday").document(currentUserEmail)
            .collection(DateManager.shared.getCurrentDayDDMMYYYY())
        
        do {
            _ = try documentRef.addDocument(from: newFood) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } catch {
            print("Error serializing food data: \(error)")
            completion(false)
        }
        saveTagertCalories(email: currentUserEmail)
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
        if user.sex == "Nam" || user.sex == "nam" {
            sex = .male
        } else {
            sex = .female
            
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
