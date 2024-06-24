//
//  MessageRow.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 24/5/24.
//

import SwiftUI

struct MessageRow: View {
    let viewModel: SuggestViewModel
    var message: Message
    @State var addedToPlan: Bool = false
    @State var listFoodSelected: [Foods] = []
    @State var enableAddPlan: Bool = false
    
    var body: some View {
        HStack {
            switch(message.type){
            case .myMessage:
                Spacer()
                Text(message.text)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
            case .mealType:
                VStack(alignment: .leading, content: {
                    Text("Chọn bữa ăn mà bạn muốn gợi ý:").font(.subheadline)
                    SelectTypeItem(type: .breakfast, viewModel: viewModel)
                    SelectTypeItem(type: .lunch, viewModel: viewModel)
                    SelectTypeItem(type: .dinner, viewModel: viewModel)
                    SelectTypeItem(type: .snacks, viewModel: viewModel)
                }).padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                Spacer()
            case .suggest:
                VStack{
                    ForEach(message.foods, id: \.self){ food in
                        HStack{
                            Text(food.name)
                            Spacer()
                            Text("\(Int(food.calorie)) kcal").frame(width: 80.0)
                            Spacer().frame(width: 20)
                            CheckBox(isChecked: Binding(
                                get: {
                                    listFoodSelected.contains { $0.name == food.name }
                                },
                                set: { newValue in
                                    let index = listFoodSelected.firstIndex { $0.name == food.name }
                                    if let index = index{
                                        listFoodSelected.remove(at: index)
                                    } else {
                                        listFoodSelected.append(food)
                                    }
                                    enableAddPlan = !listFoodSelected.isEmpty && !addedToPlan
                                }
                            ), checkBoxColor: .blue)
                        }
                    }
                    AddToPlanItem(enable: $enableAddPlan){
                        if !listFoodSelected.isEmpty {
                            viewModel.addFoodToPlan(listFoodSelected)
                            addedToPlan = true
                            enableAddPlan = false
                        }
                    }
                }.padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                Spacer()
            default:
                Text(message.text)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                if message.text == "thinking..." {
                    ProgressView(value: 0, total: 0).tint(.F_24_F_1_D)
                }
                Spacer()
            }
        }
    }
}

struct SelectTypeItem: View {
    var type: MealType
    var viewModel: SuggestViewModel
    
    var body: some View {
        Button(action: {
            viewModel.sendMessage(text: type.title, type: .mealType)
            viewModel.typePlanSuggest = type
        }, label: {
            HStack {
                Text(type.title).foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.black)
            }.padding()
                .frame(width: 200, height: 32)
                .foregroundColor(.white)
                .background(Color(.systemGray4))
                .cornerRadius(10)
                .opacity(0.9)
            
        })
    }
}

struct AddToPlanItem: View {
    @Binding var enable: Bool
    var onAddToPan: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            onAddToPan?()
        }, label: {
            HStack{
                Text("Thêm vào thực đơn")
                Spacer()
                Image(systemName: "chevron.right")
            }.padding()
                .frame(height: 40)
                .foregroundColor(.white)
                .background(Color(enable ? .systemBlue : .gray))
                .cornerRadius(10)
                .opacity(0.9)
            
        }).disabled(!enable)
    }
}


struct OtherPlan: View {
    @Binding var enable: Bool
    var onAddToPan: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            onAddToPan?()
        }, label: {
            HStack{
                Text("Lựa chọn khác")
                Spacer()
                Image(systemName: "chevron.right")
            }.padding()
                .frame(height: 40)
                .foregroundColor(.white)
                .background(Color(enable ? .systemBlue : .gray))
                .cornerRadius(10)
                .opacity(0.9)
            
        }).disabled(!enable)
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageRow(viewModel: SuggestViewModel(), message: Message(text: "aaaaaa", type: .mealType))
        }
    }
}
