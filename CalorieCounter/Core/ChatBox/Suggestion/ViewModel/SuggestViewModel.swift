//
//  SuggestViewModel.swift
//  CalorieCounter
//
//  Created by 
//

import Foundation
import OpenAISwift
import KRProgressHUD

enum MessageType: Encodable, Decodable {
    case myMessage
    case reply
    case mealType
    case suggest
}

struct Message: Identifiable, Encodable, Decodable {
    var id = UUID()
    var text: String
    var type: MessageType
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
        self.text = Message.THINKING
        self.type = .reply
    }
    static let THINKING = "Đang xử lý dữ liệu..."
}

class SuggestViewModel : ObservableObject{
    @Published var messages: [Message] = []
    @Published var addToPlanError: String? = ""
    let firebaseApi = FirebaseAPI.shared
    let openAI = OpenAISwift(authToken: "")
    var foods: [Foods] = []
    var typePlanSuggest: MealType?
    var user: UserGoals = UserGoals.instance
    var timer: Timer?
    
    
    init(){
        firebaseApi.getAllFood(onCompleted: { foods, error in
            self.foods = foods
        })
        firebaseApi.getAllMessages(onCompleted: { messages, error in
            self.messages = messages
        })
    }
    
    func sendMessage(text: String, type: MessageType){
        appendMessage(Message(text: text, type: .myMessage))
        switch(type){
        case .myMessage:
            if text.lowercased().contains("gợi ý thực đơn"){
                appendMessage(Message(text: "", type: .mealType))
            }else {
                appendMessage(Message())
                questiontoChatGpt(text: text)
            }
        case .mealType:
            appendMessage(Message())
            getListFoodSuggest(type: text, notSame: [])
        default:
            print("sendMessage")
        }
    }
    
    func appendMessage(_ message: Message){
        messages.append(message)
        if message.text != Message.THINKING {
            firebaseApi.saveMessage(message: message, onCompleted: { result, error in
                print("save message: \(result)")
            })
        }
    }
    
    func questiontoChatGpt(text: String){
        openAI.sendChat(with: [ChatMessage(role: .user, content: text)], presencePenalty: nil) { [self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.sync {
                    messages.removeLast()
                    appendMessage(Message(text: success.choices?.first?.message.content ?? "", type: .reply))
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
                    appendMessage(Message(text: "", type: .suggest, foods: arrayFood))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(suggestTimeout), userInfo: nil, repeats: false)
    }
    
    @objc func suggestTimeout(){
        for i in messages.indices {
            if messages[i].text == Message.THINKING {
                messages[i] = Message(text: "Hãy thử lại sau ít phút", type: .reply)
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
        guard let type = typePlanSuggest else {return}
        KRProgressHUD.show()
        firebaseApi.addFoodToPlan(type, foods){ error in
            self.addToPlanError = error?.localizedDescription
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                KRProgressHUD.dismiss()
            })
        }
    }
}
