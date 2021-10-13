//
//  debug.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

#if DEBUG
/// Last line used in debug
var lastDebugLine: String?

/// How many times the line was repeated
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
