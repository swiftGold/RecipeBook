//
//  CategoriesCollectionViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 03.03.2023.
//

import UIKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Create UI
    private let mainImageView = make(UIImageView()) {
        $0.image = UIImage(named: "placeholderImage")
        $0.contentMode = .scaleToFill
    }
    
    private let descriptionLabel = make(UILabel()) {
        $0.text = "Kelewele Ghanian Recipe"
        $0.textColor = .white
		$0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
		$0.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with categoryTitle: String) {
		descriptionLabel.text = categoryTitle
		mainImageView.image = UIImage(named: "\(categoryTitle)")
    }
}

//MARK: - Private methods
private extension CategoriesCollectionViewCell {
    func setupCell() {
        
        contentView.myAddSubView(mainImageView)
        contentView.myAddSubView(descriptionLabel)
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
			descriptionLabel.centerXAnchor.constraint(equalTo: mainImageView.centerXAnchor)
        ])
    }
}
