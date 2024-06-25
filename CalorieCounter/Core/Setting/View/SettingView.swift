//
//  SettingView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 12/5/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = GoalViewModel.instance
    @ObservedObject var userGoal = UserGoals.instance
    @State var showProfileView: Bool = false
    @State var isActive: Bool = false
    @State var logoutSuccessful = false
    
    var body: some View {
        ZStack {
            Color.cl_FAFAFA()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Header
                Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 50)
                SettingFeature
                Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 470)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension SettingView {
    var Header: some View {
        ZStack {
            Color.cl_F24F1D()
                .edgesIgnoringSafeArea(.all)
            VStack() {
                Spacer().frame(height:  Vconst.DESIGN_HEIGHT_RATIO * 25)
                HStack {
                    BackButton() {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                    Text("Cài đặt")
                        .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 25 ))
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 15)
                Spacer()
             }
        }
    }
    
    var SettingFeature: some View {
        VStack {
            ForEach(SettingEnum.allCases, id: \.self) { item in
                switch item {
                case  .update:
                    ItemRowSetting(title: item.title, setting: item, image: "next") {
                        showProfileView = true
                    }
                case .logout:
                    NavigationLink(destination: LoginView(), isActive: $logoutSuccessful) {
                        ItemRowSetting(title: item.title, setting: item, image : "logout"){
                            viewModel.logout()
                            UserDefaults.deleteEmailPassword()
                            logoutSuccessful = true
                        }
                    }
                }

            }
        }
        .navigationDestination(isPresented: $showProfileView) {
            ProfileView()
        }
    }
}

struct ItemRowSetting: View {
    @ObservedObject var viewModel = GoalViewModel.instance
    let title: String
    var setting: SettingEnum = .update
    var image: String
    var onAction: (() -> Void)?
    var body: some View {
        Button(action: {
            onAction?()
        }, label: {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 18)
                Spacer()
                Image("\(image)")
                    .resizable()
                    .frame(width: Vconst.DESIGN_WIDTH_RATIO * 20, height: Vconst.DESIGN_HEIGHT_RATIO * 20)
                    .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 10)
            }
            .foregroundColor(.black)
            .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 18)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal,  Vconst.DESIGN_WIDTH_RATIO * 20)
            .padding(.top,  Vconst.DESIGN_HEIGHT_RATIO * 10)
        })
    }
}



#Preview {
    SettingView()
}
