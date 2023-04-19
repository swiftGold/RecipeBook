//
//  GenlCollectionViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 03.03.2023.
//

import UIKit

//MARK: - GenlCollectionViewCellDelegate
protocol GenlCollectionViewCellDelegate: AnyObject {
    func didTapBookmarkButton(with index: Int)
    func didTapMoreButton(with index: Int)
}

final class GenlCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Create UI
    private let mainImageView = make(UIImageView()) {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.image = UIImage(named: "placeholderImage")
    }
    
    private let rateImageView = make(UIImageView()) {
        $0.clipsToBounds = true
        $0.image = UIImage(systemName: "hand.thumbsup")
        $0.tintColor = .black
    }
    
    private let rateLabel = make(UILabel()) {
        $0.text = "4,5 "
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let rateStackView = make(UIStackView()) {
        $0.spacing = 3
        $0.distribution = .fill
        $0.alignment = .trailing
        $0.axis = .horizontal
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 7
    }

    private lazy var bookmarkButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapbookmarkButton), for: .touchUpInside)
        $0.setImage(UIImage(named: "bookmark1")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let durationLabel = make(UILabel()) {
        $0.text = " 2:10 "
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 7
        $0.clipsToBounds = true
    }
    
    private let descriptionLabel = make(UILabel()) {
        $0.text = "How to sharwama at home"
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private lazy var moreButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        $0.setImage(UIImage(systemName: "ellipsis.vertical.bubble"), for: .normal)
        $0.tintColor = .black
    }
    
    private let descriptionStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    weak var delegate: GenlCollectionViewCellDelegate?
    private var recipeIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with model: GenlViewModel) {
        recipeIndex = model.id
        descriptionLabel.text = model.title
        durationLabel.text = " \(Int(model.readyInMinutes)) mins "
        rateLabel.text = "\(model.aggregateLikes) "
        guard let image = model.image else { return }
        mainImageView.downloaded(from: image)
        
        if model.isSaved {
            bookmarkButton.setImage(UIImage(named: "redBookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "bookmark1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK: Objc methods
    @objc
    private func didTapMoreButton() {
        delegate?.didTapMoreButton(with: recipeIndex)
    }
    
    @objc
    private func didTapbookmarkButton() {
        delegate?.didTapBookmarkButton(with: recipeIndex)
    }
}

//MARK: - Private methods
private extension GenlCollectionViewCell {
    func setupCell() {
        
        rateStackView.addArrangedSubview(rateImageView)
        rateStackView.addArrangedSubview(rateLabel)
        
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(moreButton)
        
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(descriptionStackView)
        
        contentView.myAddSubView(mainStackView)
        contentView.myAddSubView(rateStackView)
        contentView.myAddSubView(bookmarkButton)
        contentView.myAddSubView(durationLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            rateStackView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 10),
            rateStackView.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor, constant: 10),
            
            bookmarkButton.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 10),
            bookmarkButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -10),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 32),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 32),
            
            durationLabel.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: -10),
            durationLabel.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -10),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            moreButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
