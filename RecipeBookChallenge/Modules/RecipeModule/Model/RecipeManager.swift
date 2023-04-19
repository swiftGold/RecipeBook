//
//  RecipeManager.swift
//  RecipeBookChallenge
//
//  Created by user on 1.03.23.
//

import Foundation

protocol RecipeManagerDelegate {
    func fetchRecipe()
}

struct RecipeManager {
    
    
    var delegate: RecipeManagerDelegate?
    

    
    mutating func fetchRecipe() {
        let url = "https://api.spoonacular.com/recipes/71642/ingredientWidget.json?apiKey=fc647a0143de42fb86cb50986d620f4c"
        getPerform(url: url)
    }
    
    
func getPerform(url: String) {
        if let url1 = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url1) { data, response, error in
                if error != nil {
                    print("error")
                }
                if let safeData = data {
                  let  recipe = parserJson(recipeData: safeData)
                }
            }
            task.resume()
        }
    }

    
    func parserJson (recipeData: Data) -> RecipeModelDecoder? {
        let decoder = JSONDecoder()
        do {
            let decoderData = try decoder.decode(RecipeModelDecoder.self, from: recipeData)
            return decoderData
        } catch {
          print("error1")
            return nil
        }
    }
    
}
