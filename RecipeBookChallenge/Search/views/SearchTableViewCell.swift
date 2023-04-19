//
//  SearchTableViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 08.03.2023.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

    //MARK: - Create UI
    private let ingredientLabel = make(UILabel()) {
        $0.text = "Apples"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: SearchModel) {
        ingredientLabel.text = model.title
    }
}

//MARK: - Private methods
private extension SearchTableViewCell {
    func setupCell() {
        myAddSubView(ingredientLabel)
        
        NSLayoutConstraint.activate([
            ingredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ingredientLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
