//
//  PlanViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 8/6/24.
//

import Foundation
import FirebaseFirestore
import KRProgressHUD

class PlanViewModel: ObservableObject {
    @Published var planToday: PlanModel = PlanModel()
    @Published var allPlan: [PlanModel] = []
    @Published var historyList: [MealType:[Foods]] = [:]
    private let firebaseApi = FirebaseAPI.shared
    private var snapshotListener: ListenerRegistration? = nil
    
    func listenPlanToday(){
        let idPlan = DateManager.shared.getCurrentDayDDMMYYYY()
        snapshotListener = firebaseApi.getPlanRef()?.collection("date").addSnapshotListener { [weak self] snap, error in
            snap?.documents.forEach({ querySnap in
                if querySnap.documentID == idPlan {
                    do {
                        self?.planToday = try querySnap.data(as: PlanModel.self)
                    }catch {
                        
                    }
                }
            })
        }
    }
    
    func getAllPlan(){
        KRProgressHUD.show()
        firebaseApi.getAllPlan { [weak self] plans, error in
            KRProgressHUD.dismiss()
            self?.allPlan = plans
            plans.forEach { plan in
                if plan.date == DateManager.shared.getCurrentDayDDMMYYYY() {
                    self?.planToday = plan
                }
            }
        }
    }
    
    func clearSnapshotListener(){
        snapshotListener?.remove()
    }
    
}
