////
////  FoodRow.swift
////  CalorieCounter
////
////  Created by Thanh Hien on 1/5/24.
////
//
//import Foundation
//import SwiftUI
//
//struct FoodRow: View {
//        
//    var food: FoodStruct
//    //var viewStore: ViewStore<SearchState, SearchAction>
//    @State var isTapped = false
//    var body: some View {
//        HStack(spacing: 0) {
//            Image(food.image)
//                .resizable()
//                .scaledToFit()
//                .frame(width: Vconst.DESIGN_WIDTH_RATIO * 100)
//            VStack(spacing: 0) {
//                Text(food.label ?? "")
//                    .font(.system(size: 16))
//                    .fontWeight(.medium)
//                Text("\(food.calorie)")
//                    .font(.system(size: 12))
//                    .fontWeight(.medium)
//                    .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 10)
//                Spacer()
//                
//            }
//            .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 10)
//            Spacer()
//            Button(action: {
//                
//            }) {
//                Image(uiImage: #imageLiteral(resourceName: "add-maeal-button"))
//            }
//        }
//        .frame(height: 68)
//        .padding(.leading,10)
//        .listRowBackground(Color.white)
//    }
//}
//
//#Preview {
//    FoodRow()
//}
