//
//  SuggestViewModel.swift
//  CalorieCounter
//
//  Created by 
//

import Foundation
import OpenAISwift

class SuggestViewModel{
    @Published var foodsSuggest : [FoodSuggest] = []
    let openAI = OpenAISwift(authToken: "")
    
    func getListFoodSuggest(type: MealType, targetCalories: Int, notSame: [FoodSuggest] = []){
        print("##### => getListFoodSuggest")
        let message = "Please suggest me some options for \(type.title), so that the number of calories is approximately \(targetCalories)\(notSame.isEmpty ? "" : ", and it cannot overlap with \(notSame.map({$0.name}).joined(separator: ","))") . Please list in json the name of the dish and the number of calories of each ingredient"
        openAI.sendChat(with: [ChatMessage(role: .user, content: message)], presencePenalty: nil) { result in
            switch result {
            case .success(let success):
                print(success.choices ?? "")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}
