//
//  MainBrain.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

protocol MainBrainProtocol {}

final class MainBrain {
    private var recipes: RecipesResponseModel?
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
}

extension MainBrain: MainBrainProtocol {}
