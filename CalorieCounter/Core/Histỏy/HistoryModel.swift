//
//  HistoryModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import Foundation
import FirebaseFirestoreInternal
import FirebaseAuth

class HistoryModel: ObservableObject {
    
    func saveFood(foodToday: [FoodToday]) {
        fetchCaloriesConsumed(completion: { caloriesConsumed in
            let history = History(listFood: foodToday, date: DateManager.shared.getCurrentDayDDMMYYYY(), totalCalorie: caloriesConsumed)
            self.saveOrUpdateHistory(history: history)
            self.updateCaloriesUserData()
            self.deleteAllFoodToday()
        })
        DateManager.shared.saveCurrentDate()
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
                .collection("data").document(DateManager.shared.getCurrentDayDDMMYYYY())
            try documentRef.setData(from: history, merge: true)
            
//            documentRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    if let currentData = document.data(), var existingHistory = currentData["history"] as? [[String: Any]] {
//                        existingHistory.append(jsonObject)
//                        documentRef.updateData(["history": existingHistory]) { error in
//                            if let error = error {
//                                print("Error updating document: \(error)")
//                            } else {
//                                print("Document successfully updated!")
//                            }
//                        }
//                    } else {
//                        print("Document data was empty or format was unexpected")
//                        documentRef.setData(["history": [jsonObject]]) { error in
//                            if let error = error {
//                                print("Error writing document: \(error)")
//                            } else {
//                                print("Document successfully written!")
//                            }
//                        }
//                    }
//                } else {
//                    print("Document does not exist. Creating a new document.")
//                    documentRef.setData(["history": [jsonObject]]) { error in
//                        if let error = error {
//                            print("Error writing document: \(error)")
//                        } else {
//                            print("Document successfully written!")
//                        }
//                    }
//                }
//            }
        } catch {
            print("Error encoding history: \(error)")
        }
    }
    
    func fetchHistory(completion: @escaping ([History]) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let db = Firestore.firestore()
        db.collection("History").document(email).collection("data").getDocuments { snap, error in
            var allHistory: [History] = []
            snap?.documents.forEach({ querySnap in
                do {
                    let history = try querySnap.data(as: History.self)
                    allHistory.append(history)
                }catch {
                    
                }
                completion(allHistory.sorted(by: {$0.date > $1.date}))
            })
        }
//        documentRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                guard let data = document.data(),
//                      let historyDataArray = data["history"] as? [[String: Any]] else {
//                    completion(nil)
//                    return
//                }
//                
//                let historyArray: [History] = historyDataArray.compactMap {
//                    guard let jsonData = try? JSONSerialization.data(withJSONObject: $0) else { return nil }
//                    return try? JSONDecoder().decode(History.self, from: jsonData)
//                }
//                let calendar = Calendar.current
//                //                let today = calendar.startOfDay(for: Date())
//                //                let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: today)!
//                
//                let filteredHistoryArray = historyArray.filter { history in
//                    let historyDate = history.date
//                    //                    >= sevenDaysAgo && historyDate < today
//                    //                    return historyDate
//                    return true
//                }
//                print("############ \(filteredHistoryArray)")
//                completion(filteredHistoryArray)
//            } else {
//                print("Error fetching updated history: \(error?.localizedDescription ?? "Unknown error")")
//                completion(nil)
//            }
//        }
    }

    
    func updateCaloriesUserData() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("Current user email is nil")
            return
        }
        
        let userDocumentRef = Firestore.firestore().collection("User").document(currentUserEmail)
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
        
        Firestore.firestore().collection("User").document(currentUserEmail).getDocument { (document, error) in
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
    
    func fetchFoodToday(completion: @escaping ([FoodToday]?) -> Void) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No current user logged in")
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        let documentRef = db.collection("foodToday").document(currentUserEmail).collection(DateManager.shared.getCurrentDayDDMMYYYY())
        
        documentRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil)
            } else {
                var foodArray: [FoodToday] = []
                for document in querySnapshot!.documents {
                    do {
                        let food = try document.data(as: FoodToday.self)
                        foodArray.append(food)
                    } catch {
                        print("Error decoding document into FoodToday: \(error)")
                    }
                }
                completion(foodArray)
            }
        }
    }
}

