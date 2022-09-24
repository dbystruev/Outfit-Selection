//
//  StringProtocol+byWords.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://stackoverflow.com/a/39667653/7851379

import Foundation

extension StringProtocol {
    var firstWord: String { words.first ?? "" }
    var words: [String] { components(separatedBy: .whitespaces) }
}
