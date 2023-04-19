//
//  DetailTopViewModel.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 07.03.2023.
//

struct DetailTopViewModel {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String?
    let servings: Int
    let nutrition: NutritionDetails?
    var isSaved: Bool
}
