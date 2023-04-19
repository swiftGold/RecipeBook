//
//  Helpers.swift
//  CookBook
//
//  Created by Сергей Золотухин on 27.02.2023.
//

import Foundation

public func make<T>(_ object: T, using closure: (inout T) -> Void) -> T {
    var object = object
    closure(&object)
    return object
}
