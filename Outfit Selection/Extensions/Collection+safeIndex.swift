//
//  Collection+safeIndex.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31.12.2020.
//
//  https://stackoverflow.com/a/37225027
extension Swift.Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }
}
