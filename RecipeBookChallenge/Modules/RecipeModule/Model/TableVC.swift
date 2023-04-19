//
//  TableVC.swift
//  RecipeBookChallenge
//
//  Created by user on 2.03.23.
//

import Foundation
import UIKit

class MyTableViewCell: UITableViewCell {
    private lazy var ingridient = UILabel.recipeItemLabel
    private lazy var amountIngridient = UILabel.recipeItemLabel
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "circle"), for: .normal)
        button.setBackgroundImage(UIImage(named: "checkmark.circle"), for: .selected)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    func configurateCell(model:TableModel) {

        setupCell()
        ingridient.text = model.ingtidientName
        ingridient.numberOfLines = 0
        amountIngridient.numberOfLines = 0
        amountIngridient.text = model.amountIngridient
        updateFavoriteButtonImage()
    }
  
    func setupCell() {
        addSubview(favoriteButton)
        addSubview(ingridient)
        addSubview(amountIngridient)
  

        ingridient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ingridient.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: 15),
            ingridient.trailingAnchor.constraint(equalTo: amountIngridient.leadingAnchor, constant: -5),
            ingridient.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            ingridient.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            ingridient.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])

        amountIngridient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountIngridient.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            amountIngridient.widthAnchor.constraint(equalToConstant: 90),
            amountIngridient.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            amountIngridient.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            amountIngridient.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])

        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
              NSLayoutConstraint.activate([
                favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                favoriteButton.widthAnchor.constraint(equalToConstant: 24),
                favoriteButton.heightAnchor.constraint(equalToConstant: 24)
              ])
      
    }

    @objc private func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        updateFavoriteButtonImage()
    }
    private func updateFavoriteButtonImage() {
        if favoriteButton.isSelected {
            favoriteButton.setBackgroundImage(UIImage(named: "checkmark.circle"), for: .selected)
        }else{
            favoriteButton.setBackgroundImage(UIImage(named: "circle"), for: .normal)
        }
        
        
//        favoriteButton.setBackgroundImage(favoriteButton.isSelected ? UIImage(named: "checkmark.circle") : UIImage(named: "circle"), for: .normal)
    }
}
