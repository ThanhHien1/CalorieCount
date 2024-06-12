//
//  TabBarView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 12/5/24.
//

import SwiftUI

struct TabBarView: View {
    @State var selected = 0
    var body: some View {
        VStack {
            TabView(selection: $selected) {
                DashBoardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Trang chủ")
                    }.tag(0)
                Chat(tabbarSelected: $selected)
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat box")
                    }.tag(1)
                PlanTabView()
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Kế hoạch")
                    }.tag(2)
                LineChartDemoView()
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis.ascending")
                        Text("Lịch sử")
                    }.tag(3)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TabBarView()
}
