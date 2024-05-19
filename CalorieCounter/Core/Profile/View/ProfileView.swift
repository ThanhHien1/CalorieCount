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
                    Text("BMR Update ")
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
                        Text("Change target")
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
                    ItemRowProfile(title: profile.title, number: "\(userGoal.user?.calorie ??  0)")
                case .height:
                    ItemRowProfile(title: profile.title, number: "\(((userGoal.user?.height ?? 0) * 100 ))")
                case .weight:
                    ItemRowProfile(title: profile.title, number: "\(userGoal.user?.weight ?? 0)")
                case .age:
                    ItemRowProfile(title: profile.title, number: "\(userGoal.user?.age ?? 0)")
                case .gender:
                    ItemRowProfile(title: profile.title, number: "\(String(describing: userGoal.user?.sex ?? ""))")
                case .activeness:
                    ItemRowProfile(title: profile.title, number: "\(String(describing: userGoal.user?.activeness.capitalized ?? ""))")
                }
            }
        }
    }
}


struct ItemRowProfile: View {
    let title: String
    let number: String
    @State var isPresented: Bool = false
    var body: some View {
        Button(action: {
            self.isPresented = true
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
            GoalView()
                .presentationDetents([.medium])
                                      }
    }
}


#Preview {
    ProfileView()
}
