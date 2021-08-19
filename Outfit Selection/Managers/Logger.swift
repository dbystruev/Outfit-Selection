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
    /// Load logs from bundled files
    private static var bundledLogs: [String: String] = {
        // The cache files which should be in the bundle
        let bundledFiles = ["categories", "female", "male", "other", "server"]
        
        // The content of bundled files as dictinary to return
        var bundledContent: [String: String] = [:]
        
        // Go through each file and load it from the bundle
        for bundledFile in bundledFiles {
            guard let path = Bundle.main.path(forResource: bundledFile, ofType: "txt") else { continue }
            guard let content = try? String(contentsOfFile: path) else { continue }
            guard let decoded = decode(content) else { continue }
            bundledContent[decoded.key] = decoded.value
        }
        
        debug("Loaded \(bundledContent.count) records from Bundle")
        return bundledContent
    }()
    
    /// Load logs from filesystem files
    private static var filesystemLogs: [String: String] = {
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
                // Get file content and try to decode it as dictionary element
                let content = try String(contentsOf: file as URL)
                guard let decodedContent = decode(content) else { continue }
                
                // Save decoded content
                logFilesContent[decodedContent.key] = decodedContent.value
                
            } catch {
                debug(error.localizedDescription)
            }
        }
        
        debug("Loaded \(logFilesContent.count) records from \(logDirectoryURL)")
        return logFilesContent
    }()

    /// Flag which turns to true when Logger has read its cache files
    private static var initialized = false
    
    /// The URL of the directory for logging — nil if failed to create
    private static var logDirectory: URL? = {
        // Don't initialize twice
        guard !initialized else { return logDirectoryURL }
        
        // Restore the logs
        logs = savedLogs
        
        return logDirectoryURL
    }()
    
    /// The actual URL of log directory not checking if the directory exists
    private static var logDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent("Logger")
    
    /// Variable which stores different log messages to avoid doubling
    private static var logs: [String: String] = [:]
    
    /// Runs once at the beginning to restore saved logs
    private static var savedLogs: [String: String] = {
        // Create log directory if it does not exist
        do {
            try FileManager.default.createDirectory(at: logDirectoryURL, withIntermediateDirectories: true)
        } catch {
            debug(error.localizedDescription)
            return [:]
        }
        
        // Event if we fail after that make sure we've flagged the fact we have initialized
        initialized = true

        return bundledLogs.merging(filesystemLogs) { _, new in new }
    }()
    
    // MARK: - Methods
    /// Decode file content into the key and the value
    /// - Parameter content: content from bundled or cached text file
    /// - Returns: returns a dictinary element with first string as the key and the rest as the value
    static func decode(_ content: String) -> (key: String, value: String)? {
        // First try to split the content to several lines
        let contentLines = content.split(separator: "\n")
        
        // Skip files with less than 2 lines
        guard 1 < contentLines.count else { return nil }
        
        // The first line is the key, the rest is the message
        let key = String(contentLines[0])
        let message = contentLines.dropFirst().joined(separator: "\n")
        
        // Return recovered content
        return (key: key, value: message)
    }
    
    /// Getter to the private logs
    /// - Parameter key: the key
    /// - Returns: message stored under the key
    static func get(for key: String) -> String? {
        // Check first if we have loaded the cache files
        if !initialized { logs = savedLogs }
        
        return logs[key]
    }
    
    
    /// Log messages into file system
    /// - Parameters:
    ///   - key: the key to store the messages for
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
        
        // Hash by the key
        logs[key] = message
        
        // Write the key and the message to the log
        try? "\(key)\n\(message)".write(to: filename, atomically: true, encoding: .utf8)
    }
}