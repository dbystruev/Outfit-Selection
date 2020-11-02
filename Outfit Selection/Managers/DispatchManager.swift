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
    let group = DispatchGroup()
    
    // MARK: - Init
    private init() {}
}
