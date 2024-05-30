//
//  MessageRow.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 24/5/24.
//

import SwiftUI

struct MessageRow: View {
    var message: Message
    let viewModel: SuggestViewModel
    @State
    var listFoodSelected: [Food] = []
    
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
                VStack{
                    Text("Chọn bữa ăn mà bạn muốn gợi ý:")
                    SelectTypeItem(type: "Bữa sáng", viewModel: viewModel)
                    SelectTypeItem(type: "Bữa trưa", viewModel: viewModel)
                    SelectTypeItem(type: "Bữa tối", viewModel: viewModel)
                    SelectTypeItem(type: "Bữa phụ", viewModel: viewModel)
                }.padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .frame(alignment: .leading)
                Spacer()
            case .suggest:
                VStack{
                    ForEach(message.foods){ food in
                        HStack{
                            Text(food.label ?? "")
                            Spacer()
                            Text("\(Int(food.nutrients?.ENERC_KCAL ?? 0.0)) kcal").frame(width: 80.0)
                            Spacer().frame(width: 20)
                            Toggle("", isOn: Binding(
                                get: { listFoodSelected.contains { $0.label == food.label } },
                                set: { newValue in
                                    let index = listFoodSelected.firstIndex { $0.label == food.label }
                                    if let index = index{
                                        listFoodSelected.remove(at: index)
                                    } else {
                                        listFoodSelected.append(food)
                                    }
                                }
                            ))
                            .labelsHidden()
                        }
                    }
                    AddToPlanItem(viewModel: viewModel)
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
                Spacer()
            }
        }
    }
}

struct SelectTypeItem: View {
    var type: String
    var viewModel: SuggestViewModel
    
    var body: some View {
        Button(action: {
            viewModel.sendMessage(text: type, type: .mealType)
        }, label: {
            HStack{
                Text(type)
                Spacer()
                Image(systemName: "chevron.right")
            }.padding()
                .frame(width: 140, height: 40)
                .foregroundColor(.white)
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .opacity(0.9)
                
        })
    }
}

struct AddToPlanItem: View {
    var viewModel: SuggestViewModel
    
    var body: some View {
        Button(action: {
            // todo
        }, label: {
            HStack{
                Text("Thêm vào thực đơn")
                Spacer()
                Image(systemName: "chevron.right")
            }.padding()
                .frame(width: 250, height: 40)
                .foregroundColor(.white)
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .opacity(0.9)
                
        })
    }
}

struct MessageRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageRow(message: Message(text: "aaaaaa", type: .mealType), viewModel: SuggestViewModel())
        }
    }
}
