//
//  SavedCollectionViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import UIKit

final class SavedCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Create UI
    private let mainImageView = make(UIImageView()) {
        $0.clipsToBounds = true
        $0.image = UIImage(named: "placeholderImage")
        $0.layer.cornerRadius = 8
    }
    
    private let descriptionLabel = make(UILabel()) {
        $0.text = "Kelewele Ghanian Recipe"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 5
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: SavedViewModel) {
        guard let image = model.image else { return }
        mainImageView.downloaded(from: image)
        descriptionLabel.text = model.title
    }
}

//MARK: - Private methods
private extension SavedCollectionViewCell {
    func setupCell() {
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(descriptionLabel)
        
        contentView.myAddSubView(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                    constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            mainImageView.heightAnchor.constraint(equalToConstant: 124),
            mainImageView.widthAnchor.constraint(equalToConstant: 124)
        ])
    }
}
