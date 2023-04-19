//
//  DetailView.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 06.03.2023.
//

import UIKit

final class DetailView: UIView {
    
    //MARK: - Create UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        return tableView
    }()
        
    var detailCellViewModels: [DetailCellViewModel] = []
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDetailTableView(with model: ResponseModel) {
        detailCellViewModels = model.extendedIngredients.map({
                .init(nameClean: $0.nameClean,
                      amount: $0.amount,
                      unit: $0.unit,
                      isSelected: false
                )
        })
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate Impl
extension DetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if detailCellViewModels[indexPath.item].isSelected {
            detailCellViewModels[indexPath.item].isSelected = false
        } else {
            detailCellViewModels[indexPath.item].isSelected = true
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource Impl
extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        let model = detailCellViewModels[indexPath.item]
        cell.selectionStyle = .none
        cell.configureCell(with: model)
        return cell
    }
}

//MARK: - Private methods
private extension DetailView {
    func setupView() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        myAddSubView(tableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
