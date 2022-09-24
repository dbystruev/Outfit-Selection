//
//  NSObject+className.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 01.11.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import Foundation

extension NSObject {
    // MARK: - Static Properties
    /// Static property matching the name of the current class
    static var className: String { String(describing: Self.self) }
    
    // MARK: - Properties
    /// Property matching the name of the current class
    var className: String { String(describing: Self.self) }
}
