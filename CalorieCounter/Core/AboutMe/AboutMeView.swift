//
//  AboutMe.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 25/5/24.
//

import SwiftUI

struct AboutMeView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @ObservedObject var viewModel = GoalViewModel.instance
    @ObservedObject var userGoal = UserGoals.instance
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            Color.cl_E1E2E7().opacity(0.4)
                .ignoresSafeArea()
            VStack {
                Header
                Spacer().frame(height:  Vconst.DESIGN_HEIGHT_RATIO * 50)
                HStack {
                    Text("Calories")
                        .padding(.leading,  Vconst.DESIGN_WIDTH_RATIO * 25)
                    Spacer()
                }
                CalorieView
                Spacer().frame(height:  Vconst.DESIGN_HEIGHT_RATIO * 10)
                HStack {
                    Text("BMI")
                        .padding(.leading,  Vconst.DESIGN_WIDTH_RATIO * 25)
                    Spacer()
                }
                BMIView
                Spacer().frame(height:  Vconst.DESIGN_HEIGHT_RATIO * 180)
            }
        }
    }
}

extension AboutMeView {
    var Header: some View {
        ZStack {
            Color.cl_F24F1D()
                .edgesIgnoringSafeArea(.all)
            VStack() {
                Spacer().frame(height:  Vconst.DESIGN_HEIGHT_RATIO * 10)
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            isActive = true
                        }, label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: Vconst.DESIGN_WIDTH_RATIO * 20, height: Vconst.DESIGN_HEIGHT_RATIO * 20)
                                .foregroundColor(.white)
                        })
                        .navigationDestination(isPresented: $isActive, destination: {
                            SettingView()
                        })
                        Text("Setting")
                            .font(.system(size: Vconst.DESIGN_WIDTH_RATIO * 15 ))
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 25)
                }
                Spacer()
             }
        }
    }
    
    var CalorieView: some View {
        HStack {
            VStack(spacing: 0) {
                Text("\(userGoal.user?.calorie ?? 0)")
                    .bold()
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 25))
                    .foregroundStyle(Color.red)
                Text("Kcal/day")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 16))
                    .foregroundStyle(Color.cl_F24F1D())
                    .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 5)
            }
            .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 40)
            Spacer()
            
            VStack(spacing: 0) {
                Text("\(userGoal.user?.calorie ?? 0)")
                    .bold()
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                    .foregroundStyle(Color.blue)
                Text("Calories needed")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 8))
                .foregroundStyle(.gray)            }
            .overlay(
                Circle()
                    .stroke(Color.blue.opacity(0.5), lineWidth: 3)
                    .frame(width: 90, height: 90)
            )
            .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 50)
        }
        
        .frame(width: Vconst.DESIGN_WIDTH_RATIO * 320)
        .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 45)
        .background(.white)
        .cornerRadius( Vconst.DESIGN_HEIGHT_RATIO * 10)
    }
    
    var BMIView: some  View {
        VStack {
            HStack {
                VStack(spacing: 0) {
                    Text("BMI")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 20))
                        .foregroundStyle(Color.black)
                    Text(String(format: "%.2f", userGoal.user?.bmi ?? 0))
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 16))
                        .foregroundStyle(Color.cl_F24F1D())
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                }
                Spacer()
                VStack(spacing: 0) {
                    Text("\(userGoal.user?.date ?? "")")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                        .foregroundStyle(Color.gray)
                    Text("Weight update date")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 12))
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                        .foregroundStyle(Color.yellow)
                }
                .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 20)
            }
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(Int((userGoal.user?.height ?? 0)*100)) cm")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                        .foregroundStyle(Color.black)
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                    Text("Height")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 12))
                        .foregroundStyle(Color.gray)
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 5)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(Int(userGoal.user?.weight ?? 0)) kg")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                        .foregroundStyle(Color.black)
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                    Text("Weight")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 12))
                        .foregroundStyle(Color.gray)
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 5)
                }
                .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 50)
            }
        }
        .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 50)
        .frame(width: Vconst.DESIGN_WIDTH_RATIO * 320)
        .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 45)
        .background(.white)
        .cornerRadius( Vconst.DESIGN_HEIGHT_RATIO * 10)
    }
}

#Preview {
    AboutMeView()
}
