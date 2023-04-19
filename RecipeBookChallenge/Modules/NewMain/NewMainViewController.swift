//
//  NewMainViewController.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 20.03.2023.
//

import UIKit

protocol NewMainViewControllerProtocol: AnyObject {
    func updateTable(sections: [Section])
    func routeToMoreInfoVC(with id: Int)
    func routeToDetailVC(with id: Int)
}

final class NewMainViewController: UIViewController {
    var presenter: MainPresenterProtocol?
    
    private lazy var tableView = make(UITableView()) {
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.register(TrendingTableViewCell.self, forCellReuseIdentifier: "TrendingTableViewCell")
        $0.register(SavedRecipeTableViewCell.self, forCellReuseIdentifier: "SavedRecipeTableViewCell")
        $0.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
    }
    
    private var sections: [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter?.viewDidLoad()
    }
}

extension NewMainViewController: NewMainViewControllerProtocol {
    func routeToMoreInfoVC(with id: Int) {
        let viewController = MoreInfoViewController()
        viewController.configureMoreInformationVC(with: id)
        present(viewController, animated: true)
    }
    
    func routeToDetailVC(with id: Int) {
//        let viewController = DetailViewController()
        let viewController = NewDetailViewController()
        viewController.configureDetailViewController(with: id)
        present(viewController, animated: true)
    }
    
    func updateTable(sections: [Section]) {
        self.sections = sections
        tableView.reloadData()
    }
}

extension NewMainViewController: UITableViewDelegate {}

extension NewMainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = sections[indexPath.section].rows[indexPath.row]
        
        switch rowType {
            
        case let .trendingRow(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingTableViewCell", for: indexPath) as? TrendingTableViewCell else { fatalError() }
            cell.configureCell(with: viewModel)
            return cell
            
        case let .savedRecipeRow(viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedRecipeTableViewCell", for: indexPath) as? SavedRecipeTableViewCell else { fatalError() }
            cell.configureCell(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        let sectionType = sections[section].type
        switch sectionType {
            
        case let .trendingSection(headerModel):
            headerView.configureHeader(with: headerModel)
        case let .savedRecipeSection(headerModel):
            headerView.configureHeader(with: headerModel)

        }
        return headerView
    }
}

private extension NewMainViewController {
    func setupViewController() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.myAddSubView(tableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
