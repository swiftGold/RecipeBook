//
//  TrendModel.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

struct RecipesResponseModel: Decodable {
    let results: [RecipesModel]
}

struct RecipesModel: Decodable {
    let id: Int
    let title: String
    let image: String
}
