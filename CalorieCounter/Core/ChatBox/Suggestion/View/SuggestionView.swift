//
//  SuggestionView.swift
//  CalorieCounter
//
//  Created by 
//

import Foundation
import SwiftUI

struct SuggestionView: View{
    let viewModel = SuggestViewModel()
    var body: some View{
        VStack{
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.foodsSuggest, id: \.self) { food in
                        Text("")
                    }
                }
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                Text("Meal Suggestion")
                    .font(.system(size: 24))
                    .foregroundStyle(.orange)
            }
        }.onAppear{
            viewModel.getListFoodSuggest(type: .lunch, targetCalories: 1000)
        }
    }
}
