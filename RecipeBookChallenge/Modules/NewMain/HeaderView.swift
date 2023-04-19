//
//  HeaderView.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 20.03.2023.
//

import UIKit

final class HeaderView: UITableViewHeaderFooterView {
    private let titleLabel = make(UILabel()) {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private lazy var actionButton = make(UIButton(type: .system)) {
        $0.addTarget(self, action: #selector(didTapHeaderButton), for: .touchUpInside)
        $0.setTitle("See all", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        $0.tintColor = .red
    }
    
    private let stackView = make(UIStackView()) {
        $0.spacing = 1
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private var action: (() -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with viewModel: HeaderViewModel) {
        titleLabel.text = viewModel.title
        action = viewModel.action
    }
    
    @objc
    private func didTapHeaderButton() {
        action?()
    }
}

private extension HeaderView {
    func setupViewController() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(actionButton)
        contentView.myAddSubView(stackView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            actionButton.widthAnchor.constraint(equalToConstant: 65)
        ])
    }
}

struct HeaderViewModel {
    let title: String
    let action: () -> Void
}
