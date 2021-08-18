//
//  Logger.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

class Logger {
    /// Log directory where all logs are stored
    static var logDirectory: URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("Logger")
        
        // Create log directory if it does not exits
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        
        return directory
    }
    
    /// Log messages into file system
    /// - Parameter messages: messages passed
    static func log(_ messages: CustomStringConvertible?...) {
        // Combine all messages into one string
        let message = messages.reduce("") { ($0.isEmpty ? "" : $0 + " ") + String(describing: $1 ?? "") }
        
        // Don't log if we already have
        guard !logs.contains(message) else { return }
        logs.insert(message)
        
        // Write the message to log
        let filename = logDirectory.appendingPathComponent(String(describing: Date().timeIntervalSince1970)).appendingPathExtension("txt")
        try? message.write(to: filename, atomically: true, encoding: .utf8)
        
        debug(filename)
    }
    
    /// Variable which stores different log messages to avoid doubling
    static var logs: Set<String> = []
}
