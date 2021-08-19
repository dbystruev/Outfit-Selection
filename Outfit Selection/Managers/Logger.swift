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
    private static var logs: Set<String> = []
    
    // MARK: - Computed Properties
    /// Runs once at the beginning to restore saved logs
    private static var savedLogs: Set<String> {
        // Content of files to be returned at the end
        var logFilesContent: Set<String> = []
        
        // Get the filest enumerator for the directory
        let files = FileManager.default.enumerator(at: logDirectoryURL, includingPropertiesForKeys: [URLResourceKey.isRegularFileKey])
        
        // Go through all the files in the directory
        while let file = files?.nextObject() as? NSURL {
            // Skip all non-txt files
            guard file.pathExtension == "txt" else { continue }
            
            // Load content of all files into returned variable
            do {
                logFilesContent.insert(try String(contentsOf: file as URL))
            } catch {
                debug(error.localizedDescription)
            }
        }
        
        return logFilesContent
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
    }
}
