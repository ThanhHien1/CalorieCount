//
//  DetailFood.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 22/6/24.
//

import SwiftUI

struct DetailFood: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var food: Foods
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack{
                BackButton(color: .black) {  self.presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Text("Thông tin Chi tiết")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundStyle(.blue)
                Spacer()
            }
            .padding(.top, Vconst.DESIGN_HEIGHT_RATIO * 20)
            .padding(.leading, Vconst.DESIGN_WIDTH_RATIO * 15)
            Spacer().frame(height: Vconst.DESIGN_HEIGHT_RATIO * 10)
            Group {
                HStack {
                    Text("Món ăn: ")
                        .bold()
                    Text(food.name)
                    Spacer()
                }
                HStack {
                    Text("Calorie: ")
                        .bold()
                    Text( String(format: "%.2f", food.calorie))
                    Spacer()
                }
                .font(.system(size: 18))
                HStack {
                    Text("Tinh bột: ")
                        .bold()
                    Text( String(format: "%.2f", food.carbohydrate))
                    Spacer()
                }
                .font(.system(size: 18))
                HStack {
                    Text("Chất béo: ")
                        .bold()
                    Text( String(format: "%.2f", food.fat))
                    Spacer()
                }
                .font(.system(size: 18))
                HStack {
                    Text("Chất xơ: ")
                        .bold()
                    Text( String(format: "%.2f", food.fiber))
                    Spacer()
                }
                HStack {
                    Text("Chất đạm: ")
                        .bold()
                    Text( String(format: "%.2f", food.protein))
                    Spacer()
                }
                .font(.system(size: 18))
                Spacer()
            }
            .padding(.leading, Vconst.DESIGN_HEIGHT_RATIO * 50)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DetailFood(food: Foods(id: "1", amount: "1", calorie: 100, carbohydrate: 1, fat: 1, fiber: 1, name: "fish", protein: 1))
}
