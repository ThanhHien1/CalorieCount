//
//  DetailHistory.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 26/6/24.
//

import SwiftUI

struct DetailHistory: View {
    var date: String = ""
    var totalFood: Int = 0
    var calories: String = ""
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(date).font(.headline)
                    .foregroundStyle(.black)
                Text("Tổng số món ăn: \(totalFood)")
                    .foregroundStyle(.gray)
                Text("Tổng calories: \(calories)")
                    .foregroundStyle(.gray)
            }
            Spacer()
            Image("next")
                .resizable()
                .frame(width: Vconst.DESIGN_WIDTH_RATIO * 30, height: Vconst.DESIGN_HEIGHT_RATIO * 30)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 5)
        .padding(.horizontal)
    }
}

#Preview {
    DetailHistory()
}
