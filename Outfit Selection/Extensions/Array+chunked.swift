//
//  Array+chunked.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 14.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks

extension Array {
    /// Chunk an array into array of few arrays of size each
    /// - Parameter size: the size of resulting arrays
    /// - Returns: the array of the arrays of size each
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
