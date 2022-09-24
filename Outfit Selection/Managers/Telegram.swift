//
//  Telegram.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.08.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import Foundation
import TDLibKit
import UIKit

/// Class to handle Telegram requests
public final class Telegram {
    // MARK: - Public Methods
    /// Initial Telegram setup
    public static func setup() {
        shared.setup()
    }
    
    // MARK: - Static Private Properties
    /// Telegram API interface
    private static let api = TdApi(client: client)
    
    /// Telegram client
    private static let client = TdClientImpl(completionQueue: .global(qos: .background), logger: shared)
    
    /// Shared Telegram instance
    private static let shared = Telegram()
    
    // MARK: - Instance Private Properties
    /// Last known authorization state
    private var authorizationState: AuthorizationState?
    
    /// Telegram API log level
    /// 0 — fatal errors
    /// 1 — errors
    /// 2 — warnings and debug warnings
    /// 3 — informational
    /// 4 — debug
    /// 5 — verbose debug
    /// 6 ... 1023 — enable more logging
    private let desiredLogLevel = 2
    
    /// Current log level (see `desiredLogLevel`)
    private var logLevel: Int?
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Private Methods
    /// Handle get authorization state response
    /// - Parameter state: new authorization state of the TDLib client
    private func authorizationStateChanged(to state: AuthorizationState) throws {
        authorizationState = state
        switch state {
        case .authorizationStateWaitTdlibParameters:
            try setTdlibParameters()
        case .authorizationStateWaitEncryptionKey:
            try Telegram.api.setDatabaseEncryptionKey(newEncryptionKey: nil, completion: { _ in })
        default:
            debug("\(state)")
        }
    }
    
    /// Collect parameters and call API setTdlibParameters method
    private func setTdlibParameters() throws {
        guard let apiHash = Global.apiKeys[.telegramApiHash] else {
            debug("WARNING: No telegramApiHash found in APIKeys.plist")
            return
        }
        guard let apiIDasString = Global.apiKeys[.telegramApiID] else {
            debug("WARNING: No telegramApiID found in APIKeys.plist")
            return
        }
        guard let apiID = Int(apiIDasString) else {
            debug("WARNING: telegramApiID found in APIKeys.plist is not a number")
            return
        }
        // Obtain the application version
        guard let infoDictionary = Bundle.main.infoDictionary else {
            debug("WARNING: Can't get info dictionary from the main bundle")
            return
        }
        let key = "CFBundleShortVersionString"
        guard let userDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            debug("WARNING: Can't get user document's directory")
            return
        }
        guard let version = infoDictionary[key] as? String else {
            debug("WARNING: No \(key) in info dictionary")
            return
        }
        let parameters = TdlibParameters(
            apiHash: apiHash,
            apiId: apiID,
            applicationVersion: version,
            databaseDirectory: userDir.path,
            deviceModel: UIDevice().model,
            enableStorageOptimizer: true,
            filesDirectory: "",
            ignoreFileNames: false,
            systemLanguageCode: Locale.current.languageCode ?? "en",
            systemVersion: "",
            useChatInfoDatabase: false,
            useFileDatabase: false,
            useMessageDatabase: false,
            useSecretChats: true,
            useTestDc: true
        )
        try Telegram.api.setTdlibParameters(parameters: parameters, completion: { _ in })
    }
    
    /// Handle set log verbosity level response
    /// - Parameter result: a success or a failure, including an associated value in each case
    private func verbosityLevel(_ result: Result<Ok, Swift.Error>) {
        switch result {
        case .failure(let error):
            debug(error.localizedDescription)
        case .success(let ok):
            logLevel = desiredLogLevel
            debug("\(ok) set log level to \(desiredLogLevel)")
        }
    }
    
    /// Handle incoming updates from the TDLib client
    /// - Parameter data: the data received from the update
    private func update(_ data: Data) {
        let api = Telegram.api
        do {
            let update = try api.decoder.decode(Update.self, from: data)
            switch update {
            case .updateAuthorizationState(let new):
                try authorizationStateChanged(to: new.authorizationState)
            default:
                if authorizationState == nil && logLevel != nil {
                    try api.getAuthorizationState(completion: { _ in })
                }
                if logLevel == nil {
                    try api.setLogVerbosityLevel(newVerbosityLevel: desiredLogLevel, completion: verbosityLevel)
                }
                debug("Unhandled: \(update)")
            }
        } catch {
            debug(error.localizedDescription)
        }
    }
    
    /// Initial Telegram setup
    private func setup() {
        Telegram.api.client.run(updateHandler: update)
    }
}

extension Telegram: TDLibKit.Logger {
    /// Log Telegram message of given type
    /// - Parameters:
    ///   - message: Telegram message to log
    ///   - type: type of the message to log
    public func log(_ message: String, type: LoggerMessageType?) {
        if desiredLogLevel < 4 { return }
        debug(type, message)
    }
}
