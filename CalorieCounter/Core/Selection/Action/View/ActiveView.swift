//
//  ActiveView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import SwiftUI

struct ActiveView: View {
    @ObservedObject var viewModel = GoalViewModel.instance
    @State var isActive: Bool = false
    var body: some View {
        VStack {
            HeaderView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 30)
            goalItemView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 80)
            ButtonContinue
            Spacer()
        }
    }
}

extension ActiveView {
    var HeaderView: some View {
        VStack {
            Text("How active are you?")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 18))
                .bold()
                .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 30)
            Text("Knowing your daily activity level helps us calculate your calorie needs more accurately.")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .padding(.horizontal, Vconst.DESIGN_HEIGHT_RATIO * 20)
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
            print( viewModel.activeness.bmh)
        }, label: {
            VStack {
                Text("\(activeItem.title)")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 15))
                Text("\(activeItem.subTitle)")
                    .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 12))
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
            }, title: "Continue" , tinColor: .white, color: Color.cl_F24F1D()
            )
        }
    }
}

#Preview {
    ActiveView()
}
