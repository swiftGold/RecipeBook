//
//  TrendView.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import UIKit

//MARK: - TrendViewDelegate
protocol TrendViewDelegate: AnyObject {
    func didTapCell(at index: Int)
    func didTapMoreInfoButton(with id: Int)
    func didTapBookmarkButton(with id: Int)
}

final class TrendView: UIView {
    
    //MARK: - Create UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 280, height: 268)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TrendCollectionViewCell.self, forCellWithReuseIdentifier: "TrendCollectionViewCell")
        return collectionView
    }()
    
    weak var delegate: TrendViewDelegate?
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    private lazy var userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager(apiService: apiService)
    
    private var viewModel: RecipesResponseModel?
    private var idArray: [Int] = []
    private var trendViewModels: [TrendViewModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDetailView(with model: RecipesResponseModel) {
        model.results.forEach { element in
            idArray.append(element.id)
        }
        
        let stringArray = idArray.map { String($0) }
        let singleString = stringArray.joined(separator: ",")
        
        Task(priority: .userInitiated) {
            do {
                let model = try await apiService.fetchManyIds(with: singleString)
                trendViewModels = model.map({
                    TrendViewModel(aggregateLikes: $0.aggregateLikes,
                                    id: $0.id,
                                    title: $0.title,
                                    readyInMinutes: $0.readyInMinutes,
                                    image: $0.image,
                                    dishTypes: $0.dishTypes,
                                    isSaved: false
                    )
                })
                await MainActor.run(body: {
                    collectionView.reloadData()
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
}

//MARK: - TrendCollectionViewCellDelegate
extension TrendView: TrendCollectionViewCellDelegate {
    func didTapBookmarkButton(with index: Int) {
        delegate?.didTapBookmarkButton(with: index)
        collectionView.reloadData()
    }
    
    func didTapMoreInfoButton(with id: Int) {
        delegate?.didTapMoreInfoButton(with: id)
    }
}

//MARK: - UICollectionViewDelegate Impl
extension TrendView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCell(at: indexPath.item)
    }
}

//MARK: - UICollectionViewDataSource Impl
extension TrendView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trendViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendCollectionViewCell", for: indexPath) as? TrendCollectionViewCell else { fatalError("") }
        
        let savedIdArray = userDefaultsManager.getIdArray()
        var model: TrendViewModel = self.trendViewModels[indexPath.item]
        
        savedIdArray.forEach { elem in
            if model.id == elem {
                model.isSaved = true
            }
        }
        
        cell.configureCell(with: model)
        cell.delegate = self
        LoadingOverlay.shared.hideOverlayView()
        return cell
    }
}

//MARK: - Private methods
private extension TrendView {
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
