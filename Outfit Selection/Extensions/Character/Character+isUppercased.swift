//
//  Character+isUppercased.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Character {
    var isUppercased: Bool { String(self) == uppercased() }
}
