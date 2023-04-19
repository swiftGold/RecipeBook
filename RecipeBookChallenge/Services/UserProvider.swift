//
//  UserProvider.swift
//  TurtleEnglish
//
//  Created by Andrey Lebedev on 02.08.2022.
//

import Foundation

protocol UserProviderProtocol {
	var isFirstLaunch: Bool { get }
}

class UserProvider: UserProviderProtocol {
	
	private enum UserDefaultsKey: String {
		case isFirstLaunch
	}
	
	private let userDefaults = UserDefaults.standard
	
	var isFirstLaunch: Bool {
		if userDefaults.bool(forKey: UserDefaultsKey.isFirstLaunch.rawValue) {
			return false
		}
		userDefaults.set(true, forKey: UserDefaultsKey.isFirstLaunch.rawValue)
		return true
	}
}
