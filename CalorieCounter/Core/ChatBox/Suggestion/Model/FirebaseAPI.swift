//
//  FirebaseAPI.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import Foundation
import FirebaseFirestore

class FirebaseAPI{
    static let shared = FirebaseAPI()
    let db = Firestore.firestore()
    
    func getAllFood(onCompleted: @escaping ([Food], Error?) -> Void ){
        db.collection("Calories").getDocuments { snapshot, error in
            if let err = error{
                onCompleted([], err)
            }
            var result: [Food] = []
            if let snapshot = snapshot {
                result = snapshot.documents.map({
                    let data = $0.data()
                    let label = data["name"] as? String ?? ""
                    let nutrients = Nutrients(ENERC_KCAL: data["calorie"] as? Float,
                                              PROCNT: data["protein"] as? Float,
                                              FAT: data["protein"] as? Float,
                                              CHOCDF: data["protein"] as? Float,
                                              FIBTG: data["protein"] as? Float)
                    return Food(foodId: $0.documentID,
                                label: label,
                                knownAs: nil,
                                nutrients: nutrients,
                                category: nil,
                                categoryLabel: nil,
                                image: nil)
                })
            }
            onCompleted(result, nil)
        }
    }
    
}
