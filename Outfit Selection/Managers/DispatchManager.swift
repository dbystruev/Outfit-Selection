//
//  DispatchManager.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 02.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import Foundation

class DispatchManager {
    // MARK: - Class Properties
    static let shared = DispatchManager()
    
    // MARK: - Instance Properties
    /// Dispatch group to run item manager network requests in parallel
    let itemManagerGroup = DispatchGroup()
    
    // MARK: - Init
    private init() {}
}
