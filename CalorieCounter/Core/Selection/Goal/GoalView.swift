//
//  GoalView.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 21/4/24.
//

import SwiftUI

struct GoalView: View {
    @ObservedObject var viewModel = GoalViewModel.instance
    @State var isActive: Bool = false
    var body: some View {
        VStack {
            HeaderView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 80)
            goalItemView
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 100)
            ButtonContinue
            Spacer()
        }
    }
}

extension GoalView {
    var HeaderView: some View {
        VStack {
            Text("What's your goal?")
                .font(.system(size: Vconst.DESIGN_HEIGHT_RATIO * 18))
                .bold()
                .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 30)
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
            print( "viewModel.goalType \(viewModel.goalType)")
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
