//
//  Arrays+commaJoined.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 27.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

extension Array {
    /// Join elements of array with comma
    var commaJoined: String {
        map { "\($0)" }.joined(separator: ",")
    }
}
