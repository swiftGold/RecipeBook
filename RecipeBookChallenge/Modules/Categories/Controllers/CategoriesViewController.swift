//
//  CategoriesViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 26.02.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    //MARK: - Create UI
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.text = "Popular categories"
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width - 40) / 2, height: 110)
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
        collectionView.register(CategoriesCollectionViewCell.self, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        return collectionView
    }()
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    private let categoryArray = CategoryArray()
        
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

//MARK: - UICollectionViewDelegate Impl
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didTapCell(at: indexPath.item)
    }
}

//MARK: - UICollectionViewDataSource Impl
extension CategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryArray.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as? CategoriesCollectionViewCell else { fatalError("") }
        
        let stringValue = categoryArray.categories[indexPath.item]
        cell.configureCell(with: stringValue)
        return cell
    }
}

//MARK: - Private methods
private extension CategoriesViewController {
    
    func didTapCell(at index: Int) {
        //получаем название категории из массива названий по indexPath.item нажатой ячейки
        let categoryName = categoryArray.categories[index]
        
        Task(priority: .userInitiated) {
            do {
                //получаем модель по названию категории, содержащую 10 рецептов из выбранной категории
                let categoryRecipes = try await apiService.fetchByCategories(with: categoryName)
                    routeToGenlViewController(with: categoryRecipes, with: index)
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
   
    func routeToGenlViewController(with model: RecipesResponseModel, with index: Int) {
        let viewController = GenlViewController()
        let titleString = categoryArray.categories[index]
        //передаем во вью контроллер модель, полученную по названию категории, содержащую 10 рецептов из выбранной категории, и название тайтла
        viewController.setupGenlViewController(with: model, with: titleString)
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

