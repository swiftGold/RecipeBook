//
//  DetailPresenter.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 23.03.2023.
//

protocol DetailPresenterProtocol {
    func viewDidLoad()
}

final class DetailPresenter {
    weak var viewController: NewDetailViewControllerProtocol?
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        
    }
}
