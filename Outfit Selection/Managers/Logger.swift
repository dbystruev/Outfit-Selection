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
    /// The URL of the directory for logging — nil if failed to create
    private static var logDirectory: URL? = {
        // Create log directory if it does not exist
        do {
            try FileManager.default.createDirectory(at: logDirectoryURL, withIntermediateDirectories: true)
        } catch {
            debug(error.localizedDescription)
            return nil
        }
        
        // Restore the logs
        logs = savedLogs
        debug("Loaded \(logs.count) records from \(logDirectoryURL)")
        
        return logDirectoryURL
    }()
    
    /// The actual URL of log directory not checking if the directory exists
    private static var logDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent("Logger")
    
    /// Variable which stores different log messages to avoid doubling
    private static var logs: [String: String] = [:]
    
    // MARK: - Computed Properties
    /// Runs once at the beginning to restore saved logs
    private static var savedLogs: [String: String] {
        // Content of files to be returned at the end
        var logFilesContent: [String: String] = [:]
        
        // Get the filest enumerator for the directory
        let files = FileManager.default.enumerator(at: logDirectoryURL, includingPropertiesForKeys: [URLResourceKey.isRegularFileKey])
        
        // Go through all the files in the directory
        while let file = files?.nextObject() as? NSURL {
            // Skip all non-txt files
            guard file.pathExtension == "txt" else { continue }
            
            // Load content of all files into returned variable
            do {
                // Get file content and split it by lines
                let content = try String(contentsOf: file as URL)
                let contentLines = content.split(separator: "\n")
                
                // Skip files with less than 2 lines
                guard 1 < contentLines.count else { continue }
                
                // The first line is the key, the rest are the message
                let key = String(contentLines[0])
                let message = contentLines.dropFirst().joined(separator: "\n")
                
                // Save restored content
                logFilesContent[key] = message
                
            } catch {
                debug(error.localizedDescription)
            }
        }
        
        return logFilesContent
    }
    
    // MARK: - Methods
    /// Log messages into file system
    /// - Parameters:
    ///   - key: the key to store the messages
    ///   - messages: messages to store under the key
    static func log(key: String, _ messages: CustomStringConvertible?...) {
        // Make sure we have a filename to write to
        guard let filename = logDirectory?.appendingPathComponent(String(describing: Date().timeIntervalSince1970)).appendingPathExtension("txt") else {
            debug("ERROR creating filename for the log")
            return
        }
        
        // Don't write to the same key twice
        guard logs[key] == nil else { return }
        
        // Combine all messages into one string
        let message = messages.reduce("") { ($0.isEmpty ? "" : $0 + "\n") + String(describing: $1 ?? "") }
        
        // Hash by first name
        logs[key] = message
        
        // Write the message to log
        try? "\(key)\n\(message)".write(to: filename, atomically: true, encoding: .utf8)
    }
}
