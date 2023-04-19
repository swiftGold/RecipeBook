//
//  AppDelegate.swift
//  RecipeBookChallenge
//
//  Created by demasek on 26.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	
	var rootViewController: UIViewController {
		let userProvider = UserProvider()
		if userProvider.isFirstLaunch {
			return SplashViewController()
		} else {
			return MainTabBarController()
		}
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		let navigationVc = UINavigationController(rootViewController: rootViewController)
		navigationVc.isNavigationBarHidden = true
        
        
        
//        let vc = NewMainViewController()
//
//        let jsonService = JSONDecoderManager()
//        let networkManager = NetworkManager(jsonService: jsonService)
//        let apiService = APIService(networkManager: networkManager)
//        let userDefaultsManager = UserDefaultsManager(apiService: apiService)
//
//        let presenter = MainPresenter(apiService: apiService, userDefaultsManager: userDefaultsManager)
//
//        vc.presenter = presenter
//        presenter.viewController = vc

        window?.rootViewController = navigationVc
        
        
        
		window?.rootViewController = navigationVc
        
		window?.makeKeyAndVisible()
		
		return true
	}
}

