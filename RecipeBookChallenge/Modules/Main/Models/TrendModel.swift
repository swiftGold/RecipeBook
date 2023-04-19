//
//  TrendModel.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

struct TrendResponseModel: Decodable {
    let results: [TrendModel]
}

struct TrendModel: Decodable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
}
