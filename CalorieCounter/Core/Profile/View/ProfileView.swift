//
//  ProfileView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 12/5/24.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = GoalViewModel.instance
    @ObservedObject var userGoal = UserGoals.instance
    @State var isActive: Bool = false
    var body: some View {
        ZStack {
            Color.cl_FAFAFA()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Header
                Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 20)
                SettingFeature
                Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 145)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if let user = userGoal.user {
                viewModel.updateInfomation(user: user )
            }
        }
    }
}

extension ProfileView {
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
                    Text("Cập nhật BMR")
                        .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 25 ))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 75)
                    Spacer()
                }
                .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 15)
                    Button(action: {
                        if let goalTypeString = userGoal.user?.goalType {
                            if let goalEnum = GoalEnum(stringValue: goalTypeString) {
                                viewModel.goalType = goalEnum
                                isActive = true
                            }
                        }
                    }, label: {
                        Text("Thay đổi mục tiêu")
                            .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 14 ))
                            .foregroundColor(.white)
                            .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO * 15)
                            .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 10)
                            .overlay {
                                RoundedRectangle(cornerRadius: Vconst.DESIGN_HEIGHT_RATIO * 20)
                                    .stroke(Color.white, lineWidth: 1)
                            }
                    })
                    .navigationDestination(isPresented: $isActive) {
                        GoalView(isHideButton: true)
                }
                Spacer()
             }
        }
    }
    
    var SettingFeature: some View {
        VStack {
            ForEach(ProfileEnum.allCases, id: \.self) { profile in
                switch profile {
                case .calories:
                    ItemRowProfile(title: profile.title, number: "\(viewModel.calorie)", profile: profile)
                case .height:
                    ItemRowProfile(title: profile.title, number: "\((Int(viewModel.height * 100)))", profile: profile)
                case .weight:
                    ItemRowProfile(title: profile.title, number: "\(Int(viewModel.weight))", profile: profile)
                case .age:
                    ItemRowProfile(title: profile.title, number: "\(Int(viewModel.age))", profile: profile)
                case .gender:
                    ItemRowProfile(title: profile.title, number: "\(viewModel.sex.title)".capitalized, profile: profile)
                case .activeness:
                    ItemRowProfile(title: profile.title, number: "\(viewModel.activeness.title)", profile: profile)
                }
            }
        }
    }
}

struct ItemRowProfile: View {
    @ObservedObject var userGoal = UserGoals.instance
    @ObservedObject var viewModel = GoalViewModel.instance
    let title: String
    let number: String
    var profile: ProfileEnum = .calories
    @State var isPresented: Bool = false
    var body: some View {
        Button(action: {
            if let activeness = ActivenessEnum(rawValue: userGoal.user?.activeness ?? "") {
                viewModel.activeness = activeness
            }
            if profile != .gender {
                self.isPresented = true
            }
        }, label: {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 18)
                Spacer()
                Text(number)
                    .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 12)
            }
            .foregroundColor(.black)
            .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 18)
            .background(.white)
            .cornerRadius(15)
            .padding(.horizontal,  Vconst.DESIGN_WIDTH_RATIO * 25)
            .padding(.top,  Vconst.DESIGN_HEIGHT_RATIO * 10)
        })
        .sheet(isPresented: $isPresented) {
            switch profile {
            case .calories:
                ChangeCalories(value: userGoal.user?.calorie ?? 0) { user in
                    viewModel.updateInfomation(user: user)
                }
                .presentationDetents([.fraction(0.4)])
            case .height:
                ChangeHeightView(value: userGoal.user?.height ?? 0) { user in
                    viewModel.updateInfomation(user: user)
                }
                .presentationDetents([.fraction(0.3)])
            case .weight:
                ChangeWeightView(value: Int(userGoal.user?.weight ?? 0)) { user in
                    viewModel.updateInfomation(user: user)
                }
                .presentationDetents([.fraction(0.3)])
            case .age:
                ChangeAgeView(value: userGoal.user?.age ?? 0) { user in
                    viewModel.updateInfomation(user: user)
                }
                .presentationDetents([.fraction(0.3)])
            case .gender:
                
                Text("")
//               break
//                ChangeHeightView(value: userGoal.user?.height ?? 0) { user in
//                    viewModel.updateInfomation(user: user)
//                }
//                .presentationDetents([.fraction(0.3)])
            case .activeness:
                ActiveView(isHideButton: true) { user in
                    viewModel.updateInfomation(user: user)
                }
                
            }
        }
       
    }
}


#Preview {
    ProfileView()
}
