//
//  SearchViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 01.03.2023.
//

import UIKit

final class SearchViewController: UIViewController {
    
    //MARK: - Create UI
    private lazy var searchBar = make(UISearchBar()) {
        $0.placeholder = "Enter ingredient here"
        $0.delegate = self
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        return tableView
    }()
    
    private let titleLabel = make(UILabel()) {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = """
        Let's find the
        tastiest recipe
        🍕
    """
    }
    
    private let apiService: APIServiceProtocol = APIService(networkManager: NetworkManager(jsonService: JSONDecoderManager()))
    private var searchResultArray: [SearchModel] = []
    
    //MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        titleLabel.isHidden = true
        let searchString = searchText
        fetchResultArray(with: searchString)
    }
}

//MARK: - UITableViewDelegate Impl
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeNumber = searchResultArray[indexPath.item].id
        routeToDetailVC(with: recipeNumber)
    }
}

//MARK: - UITableViewDataSource Impl
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let model = searchResultArray[indexPath.item]
        cell.selectionStyle = .none
        cell.configureCell(with: model)
        return cell
    }
}

//MARK: - Private methods
private extension SearchViewController {
    func routeToDetailVC(with id: Int) {
        let viewController = DetailViewController()
        viewController.configureDetailViewController(with: id)
        present(viewController, animated: true)
    }
    
    func fetchResultArray(with stringValue: String) {
        Task {
            do {
                let seachArray = try await apiService.fetchSearch(with: stringValue)
                searchResultArray = seachArray
                tableView.reloadData()
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                })
            }
        }
    }
    
    //MARK: - Setup ViewController
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.myAddSubView(searchBar)
        view.myAddSubView(tableView)
        view.myAddSubView(titleLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
}
