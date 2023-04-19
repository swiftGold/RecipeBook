//
//  UserDefaultsManager.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 11.03.2023.
//

import Foundation

protocol UserDefaultsManagerProtocol {
    func setUserDefaults(with index: Int)
    func getData() -> String
    func getIdArray() -> [Int]
}

final class UserDefaultsManager {
    let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    let defaults = UserDefaults.standard
}

//MARK: - UserDefaultsManagerProtocol
extension UserDefaultsManager: UserDefaultsManagerProtocol {
    func setUserDefaults(with index: Int) {
        do {
            var currentArrayId = UserDefaults.standard.object(forKey: "userFavorite") as? [Int] ?? [index]
            if !currentArrayId.contains(index) {
                print("id saved to UserDefaults.")
                currentArrayId.append(index)
            } else {
                print("id removed from UserDefaults.")
                currentArrayId.remove(at: currentArrayId.firstIndex(of: index)!)
            }
            defaults.set(currentArrayId, forKey: "userFavorite")
        }
    }
    
    func getData() -> String {
        let array = getIdArray()
        let stringArray = array.map { String($0) }
        let singleString = stringArray.joined(separator: ",")
        return singleString
    }
    
    func getIdArray() -> [Int] {
        let savedData: [Any] = UserDefaults.standard.array(forKey: "userFavorite") ?? []
        let array: [Int] = savedData.map { $0 as? Int ?? 0 }
        return array
    }
}
