//
//  TeamLabel.swift
//  MarathonFirstChallenge
//
//  Created by Alina Artamonova on 10.02.2023.
//

import UIKit

extension UILabel {
	static var recipeTopItemLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
		label.textColor = UIColor.black
		return label
	}
	
	static var recipeItemLabel: UILabel {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
		label.textColor = UIColor.black
		return label
	}
}
