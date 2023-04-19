//
//  UIStackView + Extensions.swift
//  TrainingApp
//
//  Created by demasek on 18.10.2022.
//

import UIKit

// Вариант его реализации в коде
// 1. Создаем переменную и даем ей имя
//	private lazy var anyStackView = UIStackView()
// 2. Реализовывам в функции setupViews()
//	anyStackView = UIStackView(arrangedSubviews: [anyLabel,			- добавляем в stackView эллементы
//													 anyImage,	- добавляем в stackView эллементы
//													 anyButton],	- добавляем в stackView эллементы
//								axis: .vertical,					- указываем какое будет расположение у эллементов
//								spacing: 5)						- указываем расстояние между этими эллементами

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
