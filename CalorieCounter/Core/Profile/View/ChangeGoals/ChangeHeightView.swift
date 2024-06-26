//
//  ChangeHeightView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 19/5/24.
//

import SwiftUI

struct ChangeHeightView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = GoalViewModel.instance
    @ObservedObject var dailySummaryData = DailySummaryData.instance
    @ObservedObject var userGoal = UserGoals.instance
    @State var value: Float = 0
    var calculatorBrain = CalculatorBrain()
    var onHeightChange: ((_ user: UserData) -> Void)?
    
    var body: some View {
        VStack {
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 20)
            Header
            Stepp
            UnitLabel
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 30)
            ButtonUpdate
            Spacer()
        }
    }
}

extension ChangeHeightView {
    
    var Header: some View {
        Text("Height")
            .font(.title)
    }
    
    var Stepp: some View {
        HStack {
            Button(action: {
                if value > 0 {
                    value -= 0.01
                }
            }) {
                Image(systemName: "minus")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO *  8)
                    .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 18)
                    .overlay {
                        RoundedRectangle(cornerRadius: Vconst.DESIGN_HEIGHT_RATIO * 22)
                            .fill(Color.cl_E1E2E7().opacity(0.4))
                    }
            }
            Spacer()
            Text("\(Int(value * 100))")
                .font(.headline)
                .foregroundColor(.black.opacity(0.6))
                .frame(width: Vconst.DESIGN_HEIGHT_RATIO * 50, alignment: .center)
            
            Spacer()
            
            Button(action: {
                value += 0.01
            }) {
                Image(systemName: "plus")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO *  8)
                    .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: Vconst.DESIGN_HEIGHT_RATIO * 20)
                            .fill(Color.cl_E1E2E7().opacity(0.4))
                    }
            }
        }
        .padding(.horizontal, Vconst.DESIGN_WIDTH_RATIO *  50)
    }
    
    var UnitLabel: some View {
        Text("cm")
    }
    
    var ButtonUpdate: some View {
        NormalButton(action: {
            updateUserHeight() {
                self.presentationMode.wrappedValue.dismiss()
                if let user = userGoal.user {
                    self.onHeightChange?(user)
                }
            }
        }, title: "Update", color: Color.cl_F24F1D(), width: Vconst.DESIGN_WIDTH_RATIO * 160)
    }
    
    private func updateUserHeight(completed: @escaping() -> Void) {
        userGoal.user?.height = value
        calculatorBrain.calculateBMI(userGoal.user?.height ?? 0.0, userGoal.user?.weight ?? 0)
        calculatorBrain.calculateCalorie(userGoal.user?.sex ?? "", userGoal.user?.weight ?? 0, userGoal.user?.height ?? 0, userGoal.user?.age ?? 0, Float(userGoal.user?.bmh ?? 0), userGoal.user?.changeCalorieAmount ?? 0)
        userGoal.user?.bmi = calculatorBrain.bmi?.value ?? 0
        userGoal.user?.calorie = Int(calculatorBrain.calorie?.rounded() ?? 0)
        print(calculatorBrain.calorie ?? 0)
        dailySummaryData.updateRemainingCalories()
        userGoal.user?.currentDay = "\(Date())"
        print("calorie: \(calculatorBrain.calorie ?? 0)")
        viewModel.updateUserData(user: userGoal.user!) {
            completed()
        }
    }
}

#Preview {
    ChangeHeightView()
}
