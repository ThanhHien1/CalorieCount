//
//  DashBoardView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 29/4/24.
//

import Foundation
import SwiftUI

struct DashBoardView: View {

    var body: some View {
        NavigationStack{
            VStack {
                CaloriesEatenAndBurnedView()
                Nutritient_Card()
                StepsProgressView()
                Spacer()
            }
            .background(
                LinearGradient(colors: [Color.white.opacity(0.7), Color.orange.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), ignoresSafeAreaEdges: [.top,.leading,.trailing])
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Image(systemName: "bell").badge(4)
                    Image(systemName: "person").badge(2)
                  }
                
                ToolbarItem(placement: .principal) {
                    Text("calorieHub")
                        .font(.system(size: 24))
                        .foregroundStyle(.orange)
                }
            }
            .navigationTitle("Today")
            
        }
    }
}


#Preview {
    DashBoardView()
}

