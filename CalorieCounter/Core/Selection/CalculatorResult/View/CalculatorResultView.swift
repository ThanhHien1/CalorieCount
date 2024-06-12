//
//  CalculatorResultView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import SwiftUI

struct CalculatorResultView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel = GoalViewModel.instance
//    @ObservedObject var dailySummaryData = DailySummaryData.instance
    @ObservedObject var userGoals = UserGoals.instance
    @State var isActive: Bool = false
   var isShowing: Bool = false
    var bmiValue: String?
    var advice: String?
    var color: UIColor?
    var calorie: String?
    
    var body: some View {
        ZStack {
            Color.cl_E1E2E7().opacity(0.4)
                .ignoresSafeArea()
            VStack {
                HeaderView
                Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 50)
                CalorieView
                HStack {
                    Text("Thống kê các chỉ số (BMI)")
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                        .padding(.leading, Vconst.DESIGN_HEIGHT_RATIO * 25)
                    Spacer()
                }
                BMIView
                Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 50)
                ButtonContinue
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

extension CalculatorResultView {
    var HeaderView: some View {
        VStack {
            HStack {
                BackButton(color: .black) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Text("Thống kê các chỉ số")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 18))
                    .bold()
                Spacer()
            }
            .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 30)
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 30)
        }
    }
    
    var CalorieView: some View {
        HStack {
            VStack(spacing: 0) {
                Text(calorie ?? "100")
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
                Text(calorie ?? "100")
                    .bold()
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                    .foregroundStyle(Color.blue)
                Text("Calories cần nạp")
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
                    Text(bmiValue ?? "18.8")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 16))
                        .foregroundStyle(Color.cl_F24F1D())
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                }
                Spacer()
                VStack(spacing: 0) {
                    Text("\(viewModel.dateUpdate)")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                        .foregroundStyle(Color.gray)
                    Text("Ngày cập nhật cân nặng")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 12))
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                        .foregroundStyle(Color.yellow)
                }
                .padding(.trailing, Vconst.DESIGN_WIDTH_RATIO * 20)
            }
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(Int(viewModel.height*100)) cm")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                        .foregroundStyle(Color.black)
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                    Text("Chiều cao")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 12))
                        .foregroundStyle(Color.gray)
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 5)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(Int(viewModel.weight)) kg")
                        .bold()
                        .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                        .foregroundStyle(Color.black)
                        .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
                    Text("Cân nâng")
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
    
    var ButtonContinue: some View {
        NavigationLink(destination: TabBarView(), isActive: $isActive) {
            NormalButton(action: {
                viewModel.saveDataUser() {
                    userGoals.fetchUserData() { result in
                        DispatchQueue.main.async {
                            isActive = true
                        }
                    }

                }
               
               
            }, title: "Continue" , tinColor: .white, color: Color.cl_F24F1D()
            )
        }
    }
    
}
#Preview {
    CalculatorResultView()
}
