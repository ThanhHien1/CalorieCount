//
//  GoalView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import SwiftUI

struct GoalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = GoalViewModel.instance
    @ObservedObject var userGoal = UserGoals.instance
    @ObservedObject var dailySummaryData = DailySummaryData.instance
    var calculatorBrain = CalculatorBrain()
    @State var isActive: Bool = false
    @State var isHideButton: Bool = false
    
    
    
    var body: some View {
        VStack {
            HeaderView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 80)
            goalItemView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 100)
            if !isHideButton {
                ButtonContinue
            }
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

extension GoalView {
    var HeaderView: some View {
        VStack {
            HStack {
                BackButton(color: .black) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                Text("What's your goal?")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 18))
                    .bold()
                    .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 60)
                Spacer()
            }
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 30)
            .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 30)
            Text("We'll personalize recommendations based on your goals.")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
        }
    }
    
    var goalItemView: some View {
        ForEach(GoalEnum.allCases, id: \.self) { goal in
            GoalItem(goalItem: goal)
                .onTapGesture {
                    print(goal)
                }
        }
    }
    
    func GoalItem(goalItem: GoalEnum) -> some View {
        Button(action: {
            viewModel.goalType = goalItem
            if isHideButton {
                updateUserGoal(userGoal: userGoal, goalItem: goalItem)
            }
        }, label: {
            HStack {
                Text("\(goalItem.title)")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 7)
                    .frame(width: Vconst.DESIGN_WIDTH_RATIO * 300)
                    .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 20)
                    .background(viewModel.goalType == goalItem ? Color.cl_F24F1D() : Color.cl_F24F1D().opacity(0.2))
                    .cornerRadius(Vconst.DESIGN_HEIGHT_RATIO * 10)
                    .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10 )
            }
        })
    }
    
    private func updateUserGoal(userGoal: UserGoals, goalItem: GoalEnum) {
        userGoal.user?.goalType = goalItem.name
        userGoal.user?.changeCalorieAmount = goalItem.changeCalorieAmount
        calculatorBrain.calculateBMI(userGoal.user?.height ?? 0.0, userGoal.user?.weight ?? 0)
        calculatorBrain.calculateCalorie(userGoal.user?.sex ?? "", userGoal.user?.weight ?? 0, userGoal.user?.height ?? 0, userGoal.user?.age ?? 0, Float(userGoal.user?.bmh ?? 0), userGoal.user?.changeCalorieAmount ?? 0)
        userGoal.user?.bmi = calculatorBrain.bmi?.value ?? 0
        userGoal.user?.calorie = Int(calculatorBrain.calorie?.rounded() ?? 0)
        print(calculatorBrain.calorie ?? 0)
        dailySummaryData.updateRemainingCalories()
        userGoal.user?.currentDay = "\(Date())"
        print("calorie: \(calculatorBrain.calorie ?? 0)")

        viewModel.updateUserData(user: userGoal.user!) {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    var ButtonContinue: some View {
        NavigationLink(destination: ActiveView(), isActive: $isActive) {
            NormalButton(action: {
                isActive = true
            }, title: "Continue" , tinColor: .white, color: Color.cl_F24F1D()
            )
        }
    }
}

#Preview {
    GoalView()
}
