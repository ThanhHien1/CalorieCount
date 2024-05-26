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
                        Text("Diary")
                    }.tag(0)
                Chat()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat box")
                    }.tag(1)
                AboutMeView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Me")
                    }.tag(2)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    TabBarView()
}
