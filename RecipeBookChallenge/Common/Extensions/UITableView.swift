//
//  UITableView.swift
//  DeliveryFood2022
//
//  Created by Сергей Золотухин on 09.09.2022.
//

import UIKit

extension UITableView {
    func register(_ cellTypes: [UITableViewCell.Type]) {
        cellTypes.forEach { self.register($0, forCellReuseIdentifier: $0.reuseIdentifier)
        }
    }
    
    func register(_ cellTypes: UITableViewCell.Type...) {
        cellTypes.forEach { self.register($0, forCellReuseIdentifier: $0.reuseIdentifier)
        }
    }
    
    func register(_ cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(String(describing: T.self)) not found")
        }
        return cell
    }
}
