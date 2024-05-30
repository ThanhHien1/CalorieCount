//
//  CalculatorView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import SwiftUI

struct CalculatorView: View {
    @State var isActive: Bool = false
    var calculatorBrain = CalculatorBrain()
    
    @ObservedObject var viewModel = GoalViewModel.instance
    var body: some View {
        VStack {
            HeaderView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 20)
            buttonGenderView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 20)
            AgeView
            HeightView
            Weightiew
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 50)
            ButtonContinue
            Spacer()
        }
    }
}

extension CalculatorView {
    var HeaderView: some View {
        VStack {
            Text("What's your BMI?")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 18))
                .bold()
                .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 30)
            Text("We need your sex, current age, height and weight to accurately calculate your BMI and calorie needs.")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .padding(.horizontal, Vconst.DESIGN_HEIGHT_RATIO * 20)
        }
    }
    
    var buttonGenderView: some View {
        HStack(spacing: 0) {
            ForEach(GenderEnum.allCases, id: \.self) { gender in
                buttonGender(gender: gender)
            }
        }
    }
    
    var AgeView: some View {
        VStack {
            HStack {
                Text("📆 Age")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                Spacer()
                Text("\($viewModel.age.wrappedValue)")
            }
            .padding(.horizontal, Vconst.DESIGN_HEIGHT_RATIO * 20)
            Slider(value: Binding(
                get: { Double(viewModel.age) },
                set: { viewModel.age = Int($0) }
            ), in: 1.0...100.0, step: 1.0)
            .padding()
            .accentColor(Color.cl_F24F1D())

        }
    }
    
    var HeightView: some View {
        VStack {
            HStack {
                Text("📏Height")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                Spacer()
                Text("\(String(format: "%.2f", viewModel.height))")
            }
            .padding(.horizontal, Vconst.DESIGN_HEIGHT_RATIO * 20)
            Slider(value: $viewModel.height, in: 0...3, step: 0.01)
                .padding()
                .accentColor(Color.cl_F24F1D())
        }
    }
    
    var Weightiew: some View {
        VStack {
            HStack {
                Text("⚖️ Weight")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                Spacer()
                Text("\(Int($viewModel.weight.wrappedValue))")
            }
            .padding(.horizontal, Vconst.DESIGN_HEIGHT_RATIO * 20)
            Slider(value: $viewModel.weight, in: 1...200, step: 1)
                .padding()
                .accentColor(Color.cl_F24F1D())
        }
    }
    
    func buttonGender(gender: GenderEnum) -> some View {
        Button(action: {
            viewModel.sex = gender
        }, label: {
            Text(gender.title)
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: Vconst.DESIGN_WIDTH_RATIO * 170)
                .padding(.vertical, Vconst.DESIGN_HEIGHT_RATIO * 14)
                .background(viewModel.sex == gender ? Color.cl_F24F1D() : Color.cl_F24F1D().opacity(0.6))
                .cornerRadius(Vconst.DESIGN_HEIGHT_RATIO * 3)
        })
    }
    
    var ButtonContinue: some View {
calculatorBrain.calculateBMI(viewModel.height,viewModel.weight)
        calculatorBrain.calculateCalorie(viewModel.sex.rawValue, viewModel.weight, viewModel.height , Int(viewModel.age), viewModel.activeness.bmh, viewModel.goalType.changeCalorieAmount)
//        return NavigationLink() {
        return NormalButton(action: {
                isActive = true
            viewModel.calorie = Int(calculatorBrain.calorie?.rounded() ?? 0)
                viewModel.bmi = calculatorBrain.bmi?.value ?? 0.0
                viewModel.dateUpdate = Utilities.formatDateTime(date: Date())
            print("########Utilities.formatDateTime(date: Date()) \(Utilities.formatDateTime(date: Date()))")
            }, title: "Continue" , tinColor: .white, color: Color.cl_F24F1D()
            )
            .navigationDestination(isPresented: $isActive, destination: {
                CalculatorResultView(bmiValue: calculatorBrain.getBMIValue(), advice: calculatorBrain.getAdvice(), color: calculatorBrain.getColor(), calorie: calculatorBrain.getCalorie())
            })
//        }
    }
}

#Preview {
    CalculatorView()
}
