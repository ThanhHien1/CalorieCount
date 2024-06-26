//
//  HistoryViewModel.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class HistoryViewModel: ObservableObject {
    @Published var historyResult: [HistoryModel] = []
    @Published var mockBarChartDataSet: BarChart.DataSet = BarChart.DataSet(elements: [])
    
    func getAllHistory(completion: @escaping ([HistoryModel]) -> Void) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            print("No current user logged in")
            completion([])
            return
        }
        historyResult.removeAll()
        let db = Firestore.firestore()
        let documentRef = db.collection("foodToday").document(currentUserEmail)
        let last7Day = DateManager.shared.getLast7DaysDates()
        var totalFetchedDays = 0
        
        for day in last7Day {
            documentRef.collection(day).getDocuments { [self] (querySnapshot, error) in
                totalFetchedDays += 1
                var foodArray: [FoodToday] = []
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            let food = try document.data(as: FoodToday.self)
                            foodArray.append(food)
                        } catch {
                            print("Error decoding document into FoodToday: \(error)")
                        }
                    }
                }
                var history = HistoryModel()
                history.date = day
                history.foods = foodArray
                history.totalCalories = foodArray.reduce(0.0, { i, v in
                    i + v.foods.reduce(0.0, { i, v in
                        i + v.calorie
                    })
                })
                GoalViewModel.instance.getTagertCalories(day: history.date) { [self] target in
//                    guard history.target != 0 else { return }
                    history.target = target
                    historyResult.insert(history, at: 0)
                    addBarToChart()
                    if totalFetchedDays == last7Day.count {
                        completion(historyResult)
                    }
                }
            }
        }
    }
    
    func addBarToChart() {
        let elements = historyResult.sorted(by: {$0.date < $1.date}).map({ history in
            let items = [BarChart.DataSet.DataElement.Bar(value: Double(history.totalCalories), color: Color.green, selectionColor: Color.green),BarChart.DataSet.DataElement.Bar(value: history.target, color: Color.red, selectionColor: Color.red)]
            return BarChart.DataSet.DataElement(date: nil, xLabel: history.date, bars: items)
        })
        mockBarChartDataSet = BarChart.DataSet(elements: elements)
    }
}
