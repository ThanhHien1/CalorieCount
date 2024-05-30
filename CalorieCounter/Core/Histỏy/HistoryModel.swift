//
//  HistoryModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import Foundation
import FirebaseFirestoreInternal
import FirebaseAuth

class HistoryModel {
    
    func saveFood() {
        //        if DateManager.shared.isNewDay()  {
        fetchCaloriesConsumed(completion: { caloriesConsumed in
            print("$$$$$$$$$")
            self.fetchFoodToday(completion: { foods in
                guard let foods = foods else { return }
                let history = History(listFood: foods, date: Utilities.formatDate(date: DateManager.shared.getLastCheckedDate() ?? .now), totalCalorie: caloriesConsumed)
                self.saveOrUpdateHistory(history: history)
                self.updateCaloriesUserData()
                self.deleteAllFoodToday()
            })
            
        })
        
        DateManager.shared.saveCurrentDate()
        //        }
        //        }
    }
    
    func saveOrUpdateHistory(history: History) {
        let db = Firestore.firestore()
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No current user logged in")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(history)
            guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                print("Error converting JSON object")
                return
            }
            
            let documentRef = db.collection("History").document(currentUserEmail)
            
            documentRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let currentData = document.data(), var existingHistory = currentData["history"] as? [[String: Any]] {
                        existingHistory.append(jsonObject)
                        documentRef.updateData(["history": existingHistory]) { error in
                            if let error = error {
                                print("Error updating document: \(error)")
                            } else {
                                print("Document successfully updated!")
                            }
                        }
                    } else {
                        print("Document data was empty or format was unexpected")
                        documentRef.setData(["history": [jsonObject]]) { error in
                            if let error = error {
                                print("Error writing document: \(error)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                    }
                } else {
                    print("Document does not exist. Creating a new document.")
                    documentRef.setData(["history": [jsonObject]]) { error in
                        if let error = error {
                            print("Error writing document: \(error)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                }
            }
        } catch {
            print("Error encoding history: \(error)")
        }
    }
    
    private func fetchUpdatedHistory(for email: String, completion: @escaping ([History]?) -> Void) {
        let db = Firestore.firestore()
        let documentRef = db.collection("History").document(email)
        
        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data(),
                      let historyDataArray = data["history"] as? [[String: Any]] else {
                    completion(nil)
                    return
                }
                
                let historyArray: [History] = historyDataArray.compactMap {
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: $0) else { return nil }
                    return try? JSONDecoder().decode(History.self, from: jsonData)
                }
                completion(historyArray)
            } else {
                print("Error fetching updated history: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    func updateCaloriesUserData() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Current user email is nil")
            return
        }
        
        let userDocumentRef = Firestore.firestore().collection("UserInformations").document(currentUserEmail)
        var dataToUpdate: [String: Any] = [
            "currentCarbs" : 0,
            "currentPro": 0,
            "currentFat": 0,
            "currentBreakfastCal": 0,
            "currentLunchCal": 0,
            "currentDinnerCal": 0,
            "currentSnacksCal": 0,
            "currentBurnedCal": 0,
            "caloriesConsumed": 0
        ]
        
        userDocumentRef.updateData(dataToUpdate) { error in
            if let error = error {
                print("Error updating user data: \(error)")
            } else {
                print("User data updated successfully")
            }
        }
    }
    
    func deleteAllFoodToday() {
        let db = Firestore.firestore()
        
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No current user logged in")
            return
        }
        
        let documentRef = db.collection("foodToday").document(currentUserEmail)
        
        documentRef.delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func fetchCaloriesConsumed(completion: @escaping(Int) -> Void) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            return
        }
        
        Firestore.firestore().collection("UserInformations").document(currentUserEmail).getDocument { (document, error) in
            if let error = error {
                return
            }
            
            guard let document = document, document.exists else {
                let documentNotFoundError = NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document not found"])
                return
            }
            
            let caloriesConsumed = (document.data()?["caloriesConsumed"] as? Int) ?? 0
            completion(caloriesConsumed)
        }
    }
    
    func fetchFoodToday( completion: @escaping ([FoodToday]?) -> Void) {
        if let currentUserEmail = Auth.auth().currentUser?.email {
            Firestore.firestore().collection("foodToday").document(currentUserEmail).getDocument { (document, error) in
                if let document = document, document.exists {
                    guard let data = document.data(),
                          let foodDataArray = data["foods"] as? [Any] else {
                        completion(nil)
                        return
                    }
                    
                    let foodArray: [FoodToday] = foodDataArray.compactMap {
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: $0) else { return nil }
                        return try? JSONDecoder().decode(FoodToday.self, from: jsonData)
                    }
                    completion(foodArray)
                } else {
                    print("Document does not exist")
                    completion(nil)
                }
            }
        }
    }
}

