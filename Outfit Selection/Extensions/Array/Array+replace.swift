//
//  Array+replace.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 23.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

extension Array {

    @discardableResult
    mutating func replaceElement(_ oldElement: Element, withElement element: Element) -> Bool {
        if let i = firstIndex(where: { String(describing: $0) == String(describing: oldElement) }) {
            self[i] = element
            return true
        }
        return false
    }
}
