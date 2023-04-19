//
//  GenlViewController.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 03.03.2023.
//

import UIKit

final class GenlViewController: UIViewController {
    
    //MARK: - Create UI
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.text = "Theres will be any Title"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 30, height: 220)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(GenlCollectionViewCell.self, forCellWithReuseIdentifier: "GenlCollectionViewCell")
        return collectionView
    }()
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    private lazy var userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager(apiService: apiService)
    
    private var idArray: [Int] = []
    private var detailModels: [GenlViewModel] = []
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingOverlay.shared.showOverlay(view: collectionView)
        setupViewController()
    }
    
    func setupGenlViewController(with model: RecipesResponseModel, with title: String) {
        titleLabel.text = title
        idArray = model.results.map { $0.id }
        configureGenlView(with: model, with: idArray)
    }
    
    func configureGenlView(with model: RecipesResponseModel, with array: [Int]) {
        Task(priority: .userInitiated) {
            let stringArray = array.map { String($0) }
            let singleString = stringArray.joined(separator: ",")
            do {
                let modelView = try await apiService.fetchManyIds(with: singleString)
                detailModels = modelView.map({ GenlViewModel(aggregateLikes: $0.aggregateLikes,
                                                             id: $0.id,
                                                             title: $0.title,
                                                             readyInMinutes: $0.readyInMinutes,
                                                             image: $0.image,
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

//MARK: - UICollectionViewDelegate Impl
extension GenlViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeNumber = idArray[indexPath.item]
        routeToDetailVC(with: recipeNumber)
    }
}

//MARK: - UICollectionViewDataSource Impl
extension GenlViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        detailModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenlCollectionViewCell", for: indexPath) as? GenlCollectionViewCell else { fatalError("") }
        
        var model: GenlViewModel = self.detailModels[indexPath.item]
        let savedIdArray = userDefaultsManager.getIdArray()
        
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

//MARK: - GenlCollectionViewCellDelegate impl
extension GenlViewController: GenlCollectionViewCellDelegate {
    func didTapMoreButton(with index: Int) {
        routeToMoreInfoVC(with: index)
    }
    
    func didTapBookmarkButton(with index: Int) {
        userDefaultsManager.setUserDefaults(with: index)
        collectionView.reloadData()
    }
}

//MARK: - Private methods
private extension GenlViewController {
    func routeToMoreInfoVC(with id: Int) {
        let viewController = MoreInfoViewController()
        viewController.configureMoreInformationVC(with: id)
        present(viewController, animated: true)
    }
    
    func routeToDetailVC(with id: Int) {
        let viewController = DetailViewController()
        viewController.configureDetailViewController(with: id)
        present(viewController, animated: true)
    }
    
    //MARK: - Setup ViewController
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.myAddSubView(titleLabel)
        view.myAddSubView(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
    }
}

