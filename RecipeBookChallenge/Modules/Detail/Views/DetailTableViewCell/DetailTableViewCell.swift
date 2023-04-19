//
//  DetailTableViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 06.03.2023.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {
    
    //MARK: - Create UI
    private lazy var checkImageView = make(UIImageView()) {
        $0.image = UIImage(named: "circle")
    }
    
    private let ingredientLabel = make(UILabel()) {
        $0.text = "Apples"
        $0.textColor = .black
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }

    private let valueIngredientLabel = make(UILabel()) {
        $0.text = "5"
        $0.textColor = .black
        $0.textAlignment = .right
        $0.numberOfLines = 0
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: DetailCellViewModel) {
        ingredientLabel.text = model.nameClean
        let value = model.amount
        let finalValue = String(format: "%0.2f", value)
        valueIngredientLabel.text = "\(finalValue) \(model.unit)"

        if model.isSelected {
            checkImageView.image = UIImage(named: "checkmark.circle")
        } else {
            checkImageView.image = UIImage(named: "circle")
        }
    }
}

//MARK: - Private methods
private extension DetailTableViewCell {
    func setupCell() {
        myAddSubView(checkImageView)
        myAddSubView(ingredientLabel)
        myAddSubView(valueIngredientLabel)
        
        NSLayoutConstraint.activate([
            checkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            ingredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ingredientLabel.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: 10),
            
            valueIngredientLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueIngredientLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

