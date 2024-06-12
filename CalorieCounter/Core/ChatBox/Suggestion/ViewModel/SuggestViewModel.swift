//
//  SuggestViewModel.swift
//  CalorieCounter
//
//  Created by 
//

import Foundation
import OpenAISwift
import KRProgressHUD

enum MessageType{
    case myMessage
    case reply
    case mealType
    case suggest
}

struct Message: Identifiable {
    let id = UUID()
    var text: String
    let type: MessageType
    var foods: [Foods] = []

    init(text: String, type: MessageType) {
        self.text = text
        self.type = type
    }
    
    init(text: String, type: MessageType, foods: [Foods]) {
        self.text = text
        self.type = type
        self.foods = foods
    }

    init() {
        self.text = "thinking..."
        self.type = .reply
    }
}

class SuggestViewModel : ObservableObject{
    @Published var messages: [Message] = []
    @Published var addToPlanError: String? = nil
    let firebaseApi = FirebaseAPI.shared
    let openAI = OpenAISwift(authToken: "")
    var foods: [Foods] = []
    var typePlanSuggest: MealType = .breakfast
    
    init(){
        firebaseApi.getAllFood(onCompleted: { foods, error in
            self.foods = foods
        })
    }
    
    func sendMessage(text: String, type: MessageType){
        messages.append(Message(text: text, type: .myMessage))
        switch(type){
        case .myMessage:
            if text.lowercased().contains("gợi ý thực đơn"){
                messages.append(Message(text: "", type: .mealType))
            }else {
                messages.append(Message())
                questiontoChatGpt(text: text)
            }
        case .mealType:
            messages.append(Message())
            getListFoodSuggest(type: text, notSame: [])
        default:
            print("sendMessage")
        }
    }
    
    func questiontoChatGpt(text: String){
        openAI.sendChat(with: [ChatMessage(role: .user, content: text)], presencePenalty: nil) { [self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.sync {
                    messages.removeLast()
                    messages.append(Message(text: success.choices?.first?.message.content ?? "", type: .reply))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getListFoodSuggest(type: String, notSame: [String] = []){
        if foods.isEmpty {
            return
        }
        let listNameFood = foods.map({$0.name}).filter {!notSame.contains($0)}
        let messageText = "Hãy gợi ý cho tôi món ăn cho \(type), có trong danh sách \(listNameFood). Và trả chúng về dưới dạng danh sách theo format [a,b,c,d]"
        print(messageText)
        openAI.sendChat(with: [ChatMessage(role: .user, content: messageText)], presencePenalty: nil) { [self] result in
            switch result {
            case .success(let success):
                let arrayFood = decodeFoodFromChatGpt(text: success.choices?.first?.message.content ?? "")
                DispatchQueue.main.sync {
                    messages.removeLast()
                    messages.append(Message(text: "", type: .suggest, foods: arrayFood))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func decodeFoodFromChatGpt(text: String) -> [Foods]{
        print(text)
        if text.isEmpty{
            return []
        }
        if let jsonData = text.data(using: .utf8) {
            do {
                let array = try JSONDecoder().decode([String].self, from: jsonData).map({$0.lowercased()})
                let random = Number.randomFiveElements(from: array, num: 5)
                return foods.filter({ !$0.name.isEmpty && random.contains($0.name.lowercased() )})
            } catch {
                return []
            }
        } else {
            return []
        }
    }
    
    func addFoodToPlan(_ foods: [Foods]){
        KRProgressHUD.show()
        firebaseApi.addFoodToPlan(typePlanSuggest, foods){ error in
            self.addToPlanError = error?.localizedDescription
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                KRProgressHUD.dismiss()
            })
        }
    }
}
