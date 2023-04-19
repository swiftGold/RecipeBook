//
//  UITabbarController+Progress.swift
//  TurtleEnglish
//
//  Created by Andrey Lebedev on 14.09.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
	
    //MARK: - Life cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupTabBar()
		setupItems()
	}
	
	private func setupTabBar() {
		tabBar.backgroundColor = .white
		tabBar.tintColor = .black
		tabBar.unselectedItemTintColor = .gray
	}
	
	private func setupItems() {
		
		let mainVC = MainViewController()
		let categoriesVC = CategoriesViewController()
		let favoriteVC = FavoriteViewController()
		let searchVC = SearchViewController()
		
		setViewControllers([mainVC, categoriesVC, favoriteVC, searchVC], animated: true)
		
		guard let items = tabBar.items else { return }
		
		items[0].image = UIImage(named: "tabBar_main")
		items[1].image = UIImage(named: "tabBar_categories")
		items[2].image = UIImage(named: "tabBar_favorites")
		items[3].image = UIImage(named: "tabBar_search")
		
		UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .semibold) as Any], for: .normal)
	}
}
