//
//  Telegram.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 25.08.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import TDLibKit

/// Class to handle Telegram requests
public final class Telegram {
    // MARK: - Public Methods
    /// Initial Telegram setup
    public static func setup() {
        shared.setup()
    }
    
    // MARK: - Private Properties
    /// Telegram API interface
    private static let api = TdApi(client: client)
    
    /// Telegram client
    private static let client = TdClientImpl(completionQueue: .global(qos: .background), logger: shared)
    
    /// Telegram API log level
    /// 0 — fatal errors
    /// 1 — errors
    /// 2 — warnings and debug warnings
    /// 3 — informational
    /// 4 — debug
    /// 5 — verbose debug
    /// 6 ... 1023 — enable more logging
    private let logLevel = 2
    
    /// Shared Telegram instance
    private static let shared = Telegram()
    
    // MARK: - Private Init
    private init() {}
    
    // MARK: - Private Methods
    /// Initial Telegram setup
    private func setup() {
        let api = Telegram.api
        let logLevel = logLevel
        api.client.run { data in
            debug(data)
            do {
                try api.setLogVerbosityLevel(newVerbosityLevel: logLevel, completion: { result in
                    switch result {
                    case .failure(let error):
                        debug(error.localizedDescription)
                    case .success(let ok):
                        debug("\(ok) setting log level to \(logLevel)")
                        do {
                            try api.getAuthorizationState(completion: { result in
                                switch result {
                                case .failure(let error):
                                    debug(error.localizedDescription)
                                case .success(let state):
                                    switch state {
                                    case .authorizationStateWaitTdlibParameters:
                                        debug(".authorizationStateWaitTdlibParameters")
                                        // TODO: Provide Tdlib Parameters
                                    default:
                                        debug("\(state)")
                                    }
                                }
                            })
                        } catch {
                            debug(error.localizedDescription)
                        }
                    }
                })
            } catch {
                debug(error.localizedDescription)
            }
        }
    }
}

extension Telegram: TDLibKit.Logger {
    /// Log Telegram message of given type
    /// - Parameters:
    ///   - message: Telegram message to log
    ///   - type: type of the message to log
    public func log(_ message: String, type: LoggerMessageType?) {
        if logLevel < 4 { return }
        debug(type, message)
    }
}
