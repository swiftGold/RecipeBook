//
//  SplashViewController.swift
//  RecipeBookChallenge
//
//  Created by demasek on 26.02.2023.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
	enum Constants {
		static let welcomeToChallenge: String = "welcome to challenge" // Пример заполнения данных в константы, удалить строку при начале работы с контроллером
	}
	
	//MARK: - Create UI
	
	// Пример верстки кодом, удалить при начале работы с контроллером
	private lazy var welcomeToChallengeLabel: UILabel = {
		let label = UILabel()
		label.text = Constants.welcomeToChallenge
		return label
	}()
	
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setConstraints()
	}
	
	private func setupViews() {
		view.backgroundColor = .red
	}
	
	//MARK: - setConstraints
	
	private func setConstraints() {
		NSLayoutConstraint.activate([
		
		])
	}
}

