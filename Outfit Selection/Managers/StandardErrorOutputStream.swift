//
//  StandardErrorOutputStream.swift
//
//  Created by Denis Bystruev on 21.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//
//  https://stackoverflow.com/a/46883516/7851379
import Foundation

/// Text output stream for standard error
struct StandardErrorOutputStream: TextOutputStream {
    /// File handle associated with standard error file
    let standardError = FileHandle.standardError
    
    /// Write a string to standard error
    /// - Parameter string: string to write to standard error
    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            fatalError("Can't convert \(string) to UTF8")
        }
        standardError.write(data)
    }
}
