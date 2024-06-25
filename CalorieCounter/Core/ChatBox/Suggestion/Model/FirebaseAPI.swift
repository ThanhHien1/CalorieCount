//
//  FirebaseAPI.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseAPI{
    static let shared = FirebaseAPI()
    let db = Firestore.firestore()
    
    func getAllFood(onCompleted: @escaping ([Foods], Error?) -> Void){
        db.collection("Calories").getDocuments { snapshot, error in
            if let err = error{
                onCompleted([], err)
            }
            var result: [Foods] = []
            if let snapshot = snapshot {
                result = snapshot.documents.map({
                    let data = $0.data()
                    return FoodMapper.firestoreToFoods(id: $0.documentID, data: data)
                })
            }
            onCompleted(result, nil)
        }
    }
    
    func addFoodToPlan(_ mealType: MealType, _ foods: [Foods], onCompleted: @escaping (Error?) -> Void){
        let planDate = DateManager.shared.getCurrentDayDDMMYYYY()
        guard let planRef = getPlanRef()?.collection("date").document(planDate) else {return}
        planRef.getDocument { docSnap, error in
            var planData = PlanModel()
            do {
                planData = try docSnap?.data(as: PlanModel.self) ?? PlanModel()
            }catch let error {
                print("Error writing foods to Firestore: \(error)")
            }
            do{
                planData.date = planDate
                switch(mealType){
                case .breakfast:
                    planData.breakfast = foods
                case .lunch:
                    planData.lunch = foods
                case .dinner:
                    planData.dinner = foods
                case .snacks:
                    planData.snacks = foods
                }
                
                try planRef.setData(from: planData, merge: true) { error in
                    onCompleted(error)
                }
            } catch let error {
                print("Error writing foods to Firestore: \(error)")
                onCompleted(error)
            }
        }
    }
    
    func getAllPlan(onCompleted: @escaping ([PlanModel], Error?) -> Void){
        getPlanRef()?.collection("date").getDocuments { snap, error in
            var allPlan: [PlanModel] = []
            snap?.documents.forEach({ querySnap in
                do {
                    let plan = try querySnap.data(as: PlanModel.self)
                    allPlan.append(plan)
                }catch {
                    
                }
            })
            onCompleted(allPlan, error)
        }
    }
    
    func getPlanRef() -> DocumentReference?{
        guard let currentUserID = Auth.auth().currentUser?.uid else {return nil}
        return db.collection("Plans").document(currentUserID)
    }
    
    func saveMessage(message: Message, onCompleted: @escaping (Bool, Error?) -> Void){
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        do{
            try db.collection("Messages").document(currentUserID)
                .collection("data")
                .document("\(Date().timeIntervalSince1970)")
                .setData(from: message) { error in
                    onCompleted(error == nil, error)
                }
        }catch let error {
            onCompleted(false, error)
        }
    }
    
    func getAllMessages(onCompleted: @escaping ([Message], Error?) -> Void){
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        db.collection("Messages").document(currentUserID)
            .collection("data")
            .getDocuments { snap, error in
                var allMessage: [Message] = []
                snap?.documents.sorted(by: {$0.documentID < $1.documentID}).forEach({ querySnap in
                    do {
                        let plan = try querySnap.data(as: Message.self)
                        allMessage.append(plan)
                    }catch {
                        
                    }
                })
                onCompleted(allMessage, error)
            }
    }
}
