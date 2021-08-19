//
//  Logger.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 18.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

class Logger {
    // MARK: - Stored Properties
    /// The directory where all logs are stored
    static var logDirectory: URL? = {
        debug(Date())
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("Logger")
        
        // Create log directory if it does not exist
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        } catch {
            debug(error.localizedDescription)
            return nil
        }
        
        // Restore the logs
        logs = savedLogs
        
        return directory
    }()
    
    /// Variable which stores different log messages to avoid doubling
    private static var logs: Set<String> = []
    
    // MARK: - Computed Properties
    /// Runs once at the beginning to restore saved logs
    private static var savedLogs: Set<String> {
        // TODO: Implement
        return []
    }
    
    // MARK: - Methods
    /// Log messages into file system
    /// - Parameter messages: messages passed
    static func log(_ messages: CustomStringConvertible?...) {
        // Make sure we have a filename to write to
        guard let filename = logDirectory?.appendingPathComponent(String(describing: Date().timeIntervalSince1970)).appendingPathExtension("txt") else {
            debug("ERROR creating filename for the log")
            return
        }
        
        // Combine all messages into one string
        let message = messages.reduce("") { ($0.isEmpty ? "" : $0 + " ") + String(describing: $1 ?? "") }
        
        // Don't log if we already have it
        guard !logs.contains(message) else { return }
        logs.insert(message)
        
        // Write the message to log
        try? message.write(to: filename, atomically: true, encoding: .utf8)
        
        debug(filename)
    }
}
