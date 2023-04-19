//
//  NewDetailViewController.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 23.03.2023.
//

import UIKit

protocol NewDetailViewControllerProtocol: AnyObject {
    
}

final class NewDetailViewController: UIViewController {
    var presenter: DetailPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    func configureDetailViewController(with id: Int) {
        
    }
}

extension NewDetailViewController: NewDetailViewControllerProtocol {
    
}

private extension NewDetailViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
