//
//  debug.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 23.09–27.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// Text output stream for standard error
internal var errorStream = StandardErrorOutputStream()

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
///   - prefix: prefix to put before printing anything
///   - messages: custom string convertible values to print
///   - separator: separator between the fields, space by default
///   - terminator: terminator at the end of the string, `new line` by default
/// - Returns: true if printed, false if not (discardable)
@discardableResult func debug(
    line: Int = #line,
    file: String = #file,
    function: String = #function,
    prefix: String = "",
    _ messages: CustomStringConvertible?...,
    separator: String = " ",
    terminator: String = "\n"
) -> Bool {
    #if DEBUG
    let file = file.lastComponent.dropExtension
    let message = messages.reduce("") { "\($0)\(separator)\($1?.description ?? "nil")" }
    let suffix = message.count < 1025 ? "" : "... (\(message.count - 1024) more symbols)"
    let newLine = "\(prefix)\(line) \(file).\(function)\(message.prefix(1024))\(suffix)"
    if (lastDebugLine == newLine) {
        lastDebugLineRepeatCount += 1
        return false
    } else {
        if 1 < lastDebugLineRepeatCount {
            print("Previous line repeated \(lastDebugLineRepeatCount) times", to: &errorStream)
        }
        print(newLine, terminator: terminator, to: &errorStream)
        lastDebugLine = newLine
        lastDebugLineRepeatCount = 1
        return true
    }
    #endif
}
