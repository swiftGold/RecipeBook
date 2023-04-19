//
//  TrendingTableViewCell.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 20.03.2023.
//

import UIKit

protocol TrendingTableViewCellDelegate: AnyObject {
    func didTapTrendRecipeCVCell(with index: Int)
    func didTapSaveRecipe(with id: Int)
    func didTapMoreInfoButton(with id: Int)
}

final class TrendingTableViewCell: UITableViewCell {
    weak var delegate: TrendingTableViewCellDelegate?
    
    private lazy var layout = make(UICollectionViewFlowLayout()) {
        $0.itemSize = CGSize(width: 280, height: 268)
        $0.minimumLineSpacing = 20
        $0.minimumInteritemSpacing = 0
        $0.scrollDirection = .horizontal
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    private lazy var collectionView = make(UICollectionView(frame: .zero, collectionViewLayout: layout)) {
        $0.delegate = self
        $0.dataSource = self
        $0.contentInsetAdjustmentBehavior = .always
        $0.bounces = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(TrendCollectionViewCell.self, forCellWithReuseIdentifier: "TrendCollectionViewCell")
    }
    
    private var recipes: [TrendViewModel] = []
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: TrendingTVCellViewModel) {
        delegate = viewModel.delegate
        recipes = viewModel.recipes
        collectionView.reloadData()
    }
}

extension TrendingTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapTrendRecipeCVCell(with: indexPath.item)
    }
}

extension TrendingTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendCollectionViewCell", for: indexPath) as? TrendCollectionViewCell else { fatalError("") }
        cell.delegate = self
        let viewModel = recipes[indexPath.item]
        cell.configureCell(with: viewModel)
        return cell
    }
}

extension TrendingTableViewCell: TrendCollectionViewCellDelegate {
    func didTapBookmarkButton(with id: Int) {
        print(#function)
        delegate?.didTapSaveRecipe(with: id)
    }
    
    func didTapMoreInfoButton(with id: Int) {
        print(#function)
        delegate?.didTapMoreInfoButton(with: id)
    }
}

private extension TrendingTableViewCell {
    func setupViewController() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        contentView.myAddSubView(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 268)
        ])
    }
}

struct TrendingTVCellViewModel {
    let recipes: [TrendViewModel]
    let delegate: TrendingTableViewCellDelegate?
}
