//
//  TrendCollectionViewCell.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import UIKit

//MARK: - TrendCollectionViewCellDelegate
protocol TrendCollectionViewCellDelegate: AnyObject {
    func didTapMoreInfoButton(with id: Int)
    func didTapBookmarkButton(with id: Int)
}

final class TrendCollectionViewCell: UICollectionViewCell {
    
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
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.25)
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
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.25)
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
    
    private let subDescriptionLabel = make(UILabel()) {
        $0.text = "dinner, main dish"
        $0.numberOfLines = 0
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 5
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    weak var delegate: TrendCollectionViewCellDelegate?
    
    private var indexValue: Int = 0
    private var trendsViewModel: TrendViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with model: TrendViewModel) {
        
        trendsViewModel = model
        
        descriptionLabel.text = model.title
        durationLabel.text = " \(Int(model.readyInMinutes)) mins "
        rateLabel.text = "\(model.aggregateLikes) "
        guard let image = model.image else { return }
        mainImageView.downloaded(from: image)
        
        let dishString = model.dishTypes.joined(separator: ", ")
        subDescriptionLabel.text = "\(String(describing: dishString))"
        indexValue = model.id
        
        if model.isSaved {
            bookmarkButton.setImage(UIImage(named: "redBookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "bookmark1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK: Objc methods
    @objc
    private func didTapMoreButton() {
        delegate?.didTapMoreInfoButton(with: indexValue)
    }
    
    @objc
    private func didTapbookmarkButton() {
        delegate?.didTapBookmarkButton(with: indexValue)
    }
}

//MARK: - Private methods
private extension TrendCollectionViewCell {
    func setupCell() {
        
        rateStackView.addArrangedSubview(rateImageView)
        rateStackView.addArrangedSubview(rateLabel)
        
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(moreButton)
        
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(descriptionStackView)
        mainStackView.addArrangedSubview(subDescriptionLabel)
        
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
            
            mainImageView.heightAnchor.constraint(equalToConstant: 180),
            mainImageView.widthAnchor.constraint(equalToConstant: 280),
            
            moreButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
