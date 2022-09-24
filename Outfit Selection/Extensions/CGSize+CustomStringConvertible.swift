//
//  CGSize+CustomStringConvertible.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension CGSize: CustomStringConvertible {
    public var description: String { "\(width) x \(height)" }
}
