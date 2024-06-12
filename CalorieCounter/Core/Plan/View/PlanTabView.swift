//
//  PlanTabView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 8/6/24.
//

import Foundation
import SwiftUI
import KRProgressHUD

struct PlanTabView: View {
    @State private var selectedTab: Tab = .history
    @StateObject var viewModel = PlanViewModel()
    
    enum Tab {
        case history
        case plan
    }
    
    var body: some View {
        VStack {
            TopTabbarView
            if selectedTab == .history {
                PlanHistoryView(viewmodel: viewModel)
            } else {
                PlanView(viewmodel: viewModel)
            }
            Spacer()
        }.onAppear(perform: {
            viewModel.getAllPlan()
        })
    }
}

extension PlanTabView {
    
    @ViewBuilder
    var TopTabbarView : some View {
        HStack {
            Button(action: {
                selectedTab = .history
            }) {
                Text("Lịch sử")
                    .foregroundColor(selectedTab == .history ? .blue : .gray)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(selectedTab == .history ? Color.gray.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
            }
            .frame(width: 200)
            
            Button(action: {
                selectedTab = .plan
            }) {
                Text("Hôm nay")
                    .foregroundColor(selectedTab == .plan ? .blue : .gray)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(selectedTab == .plan ? Color.gray.opacity(0.2) : Color.clear)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
}

struct PlanTabView_Previews: PreviewProvider {
    static var previews: some View {
        PlanTabView()
    }
}
