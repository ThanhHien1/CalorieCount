//
//  ChartView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 30/5/24.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2]
    var body: some View {
        VStack {
//            BarChartView(data: ChartData(values: [("2018 Q411",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly") // legend is optional
            BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", legend: "Legendary")
        }
    }
}

#Preview {
    ChartView()
}
