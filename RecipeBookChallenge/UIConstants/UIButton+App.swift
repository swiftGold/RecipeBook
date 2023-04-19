//
//  UIButton+App.swift
//  TurtleEnglish
//
//  Created by Andrey Lebedev on 17.09.2022.
//

import UIKit

extension UIButton {
	public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		let context = UIGraphicsGetCurrentContext()
		context?.setFillColor(color.cgColor)
		context?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		setBackgroundImage(image, for: state)
	}
}
