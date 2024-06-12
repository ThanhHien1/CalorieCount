//
//  ActiveView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import SwiftUI

struct ActiveView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = GoalViewModel.instance
    @ObservedObject var userGoal = UserGoals.instance
    @ObservedObject var dailySummaryData = DailySummaryData.instance
    var calculatorBrain = CalculatorBrain()
    @State var isActive: Bool = false
    @State var isHideButton: Bool = false
    var onActiveChange: ((_ user: UserData) -> Void)?
    
    var body: some View {
        VStack {
            HeaderView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 30)
            goalItemView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 80)
            if !isHideButton {
                ButtonContinue
            }
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 50)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

extension ActiveView {
    var HeaderView: some View {
        VStack {
            HStack {
                BackButton(color: .black) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("Bạn vận động như thế nào?")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 18))
                .bold()
                Spacer()
            }
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 30)
            .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 30)
            Text("Biết mức độ hoạt động hàng ngày của bạn giúp chúng tôi tính toán nhu cầu calo của bạn chính xác hơn.")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .padding(.horizontal, Vconst.DESIGN_HEIGHT_RATIO * 20)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var goalItemView: some View {
        ForEach(ActivenessEnum.allCases, id: \.self) { active in
            GoalItem(activeItem: active)
        }
    }
    
    func GoalItem(activeItem: ActivenessEnum) -> some View {
        Button(action: {
            viewModel.activeness = activeItem
            if isHideButton {
                updateUserHeight() {
                    onActiveChange?(userGoal.user!)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            print( viewModel.activeness.bmh)
        }, label: {
            VStack {
                Text("\(activeItem.title)")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
//                    .padding(5)
                Text("\(activeItem.subTitle)")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 12))
                    .fixedSize(horizontal: false, vertical: true)
                
            }
            .foregroundStyle(.black)
            .multilineTextAlignment(.center)
            .padding(.top, 7)
            .frame(width: Vconst.DESIGN_WIDTH_RATIO * 300)
            .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 10)
            .background(viewModel.activeness == activeItem ? Color.cl_F24F1D() : Color.cl_F24F1D().opacity(0.2))
            .cornerRadius(Vconst.DESIGN_HEIGHT_RATIO * 10)
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10 )
        })
    }
    
    var ButtonContinue: some View {
        NavigationLink(destination: CalculatorView(), isActive: $isActive) {
            NormalButton(action: {
                isActive = true
            }, title: "Tiếp tục" , tinColor: .white, color: Color.cl_F24F1D()
            )
        }
    }
    
    private func updateUserHeight(completed: @escaping() -> Void) {
        userGoal.user?.activeness = viewModel.activeness.name
        userGoal.user?.bmh  = viewModel.activeness.bmh
        calculatorBrain.calculateBMI(userGoal.user?.height ?? 0.0, userGoal.user?.weight ?? 0)
        calculatorBrain.calculateCalorie(userGoal.user?.sex ?? "", userGoal.user?.weight ?? 0, userGoal.user?.height ?? 0, userGoal.user?.age ?? 0, Float(userGoal.user?.bmh ?? 0), userGoal.user?.changeCalorieAmount ?? 0)
        userGoal.user?.bmi = calculatorBrain.bmi?.value ?? 0
        userGoal.user?.calorie = Int(calculatorBrain.calorie?.rounded() ?? 0)
        print(calculatorBrain.calorie ?? 0)
        dailySummaryData.updateRemainingCalories()
        userGoal.user?.date = "\(Date())"
        print("calorie: \(calculatorBrain.calorie ?? 0)")
        viewModel.updateUserData(user: userGoal.user!) {
            completed()
        }
    }
}

#Preview {
    ActiveView()
}
