//
//  SavedView.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import UIKit

//MARK: - SavedViewDelegate
protocol SavedViewDelegate: AnyObject {
    func didTapSavedCell(with recipeId: Int)
}

final class SavedView: UIView {
    
    //MARK: - Create UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 210)
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SavedCollectionViewCell.self, forCellWithReuseIdentifier: "SavedCollectionViewCell")
        return collectionView
    }()
    
    private var detailModels: [SavedViewModel] = []
    
    weak var delegate: SavedViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSavedView(with model: [ResponseModel]) {
        let model = reverseArray(with: model)
        detailModels = model.map({ SavedViewModel(id: $0.id,
                                                  title: $0.title,
                                                  image: $0.image
        )
        })
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegate Impl
extension SavedView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeId = detailModels[indexPath.item].id
        delegate?.didTapSavedCell(with: recipeId)
    }
}

//MARK: - UICollectionViewDataSource Impl
extension SavedView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedCollectionViewCell", for: indexPath) as? SavedCollectionViewCell else { fatalError("") }
        
        let model = detailModels[indexPath.item]
        cell.configureCell(with: model)
        LoadingOverlay2.shared.hideOverlayView()
        return cell
    }
}

//MARK: - Private methods
private extension SavedView {
    func reverseArray(with array: [ResponseModel]) -> [ResponseModel] {
        var reversedArray = [ResponseModel]()
        for value in array.reversed() {
            reversedArray += [value]
        }
        return reversedArray
    }
    
    func setupView() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        myAddSubView(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
