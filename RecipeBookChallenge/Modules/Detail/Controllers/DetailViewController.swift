//
//  DetailViewController.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 06.03.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - Create UI
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
    }
    
    private let mainImageView = make(UIImageView()) {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private lazy var bookmarkButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapbookmarkButton), for: .touchUpInside)
        $0.setImage(UIImage(named: "bookmark1")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    private let caloriesLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let cookTimeLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let servesLabel = make(UILabel()) {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var moreButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        $0.setImage(UIImage(systemName: "ellipsis.vertical.bubble"), for: .normal)
        $0.tintColor = .black
    }
    
    private let shortInformationStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    private let shortAndButtonStackView = make(UIStackView()) {
        $0.spacing = 25
        $0.distribution = .fillProportionally
        $0.axis = .horizontal
    }
    
    private let detailView = DetailView()
    private var indexValue: Int = 0
    
    private let mainStackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    private lazy var userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager(apiService: apiService)
    
    private var idValue: Int = 0
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        LoadingOverlay.shared.showOverlay(view: mainImageView)
        setupViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadingOverlay.shared.hideOverlayView()
    }
    
    func configureDetailViewController(with index: Int) {
        Task {
            do {
                let model = try await apiService.fetchDetail(id: index)
                idValue = index
                var detailTopViewModel = DetailTopViewModel(id: model.id,
                                                            title: model.title,
                                                            readyInMinutes: model.readyInMinutes,
                                                            image: model.image,
                                                            servings: model.servings,
                                                            nutrition: model.nutrition,
                                                            isSaved: false
                )
                
                let savedIdArray = userDefaultsManager.getIdArray()
                savedIdArray.forEach { elem in
                    if detailTopViewModel.id == elem {
                        detailTopViewModel.isSaved = true
                    }
                }
                                
                configureDetailViews(with: detailTopViewModel)
                detailView.configureDetailTableView(with: model)
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
    
    //MARK: Objc methods
	@objc private func didTapbookmarkButton() {
        userDefaultsManager.setUserDefaults(with: idValue)
	}
        
    @objc
    private func didTapMoreButton() {
        routeToMoreInfoVC(with: indexValue)
    }
}

//MARK: - Private methods
extension DetailViewController {
    func routeToMoreInfoVC(with id: Int) {
        let viewController = MoreInfoViewController()
        viewController.configureMoreInformationVC(with: id)
        present(viewController, animated: true)
    }
    
    func configureDetailViews(with model: DetailTopViewModel) {
        guard let kcalValue = model.nutrition?.nutrients[.zero].amount else { return }
        guard let kcalUnit = model.nutrition?.nutrients[.zero].unit else { return }
        indexValue = model.id
        titleLabel.text = model.title
        guard let image = model.image else { return }
        mainImageView.downloaded(from: image)
        caloriesLabel.text = "\(Int(kcalValue)) \(kcalUnit)"
        cookTimeLabel.text = "\(model.readyInMinutes.intToString()) mins"
        servesLabel.text = "\(model.servings.intToString()) serves"
        
        if model.isSaved {
            bookmarkButton.setImage(UIImage(named: "redBookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(named: "bookmark1")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK: - Setup ViewController
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        shortInformationStackView.addArrangedSubview(caloriesLabel)
        shortInformationStackView.addArrangedSubview(cookTimeLabel)
        shortInformationStackView.addArrangedSubview(servesLabel)
        
        shortAndButtonStackView.addArrangedSubview(shortInformationStackView)
        shortAndButtonStackView.addArrangedSubview(moreButton)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(mainImageView)
        mainStackView.addArrangedSubview(shortAndButtonStackView)
        mainStackView.addArrangedSubview(detailView)
        
        view.myAddSubView(mainStackView)
        view.myAddSubView(bookmarkButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            bookmarkButton.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 10),
            bookmarkButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: -10),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 32),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 32),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 90),
            mainImageView.heightAnchor.constraint(equalToConstant: 220),
            shortInformationStackView.heightAnchor.constraint(equalToConstant: 90),
            moreButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
