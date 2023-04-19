//
//  TrendsViewModel.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 12.03.2023.
//

struct TrendViewModel {
    let aggregateLikes: Int
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String?
    let dishTypes: [String]
    var isSaved: Bool
}
