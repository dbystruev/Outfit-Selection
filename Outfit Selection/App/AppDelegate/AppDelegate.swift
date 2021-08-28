//
//  AppDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 19/06/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

#if DEBUG
/// Last line used in debug
var lastDebugLine: String?

/// How many times the line was repeat
var lastDebugLineRepeatCount = 0
#endif

/// Log a debug message to the console
/// - Parameters:
///   - line: current line, #line by default
///   - file: current file, #file by default
///   - function: current function, #function by default
///   - messages: message to log to the console
func debug(line: Int = #line,
           file: String = #file,
           function: String = #function,
           _ messages: CustomStringConvertible?...) {
    #if DEBUG
    let file = file.lastComponent.dropExtension
    let message = messages.reduce("") { "\($0) \($1?.description ?? "nil")" }
    let newLine = "\(line) \(file).\(function)\(message.prefix(1024))"
    if (lastDebugLine == newLine) {
        lastDebugLineRepeatCount += 1
    } else {
        if 1 < lastDebugLineRepeatCount {
            print("Previous line repeated \(lastDebugLineRepeatCount) times")
        }
        print(newLine)
        lastDebugLine = newLine
        lastDebugLineRepeatCount = 1
    }
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
    
    // MARK: - Methods
    /// Update the list of categories from the server
    func updateCategories() {
        NetworkManager.shared.getCategories { categories in
            // Make sure we don't update to the empty list of categories
            guard let categories = categories, !categories.isEmpty else { return }
            
            Category.all = categories
        }
    }
}
