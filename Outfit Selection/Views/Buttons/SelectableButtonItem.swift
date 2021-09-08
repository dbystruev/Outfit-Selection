//
//  SelectableButtonItem.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

/// UIBarButtonItem with isSelected property
class SelectableButtonItem: UIBarButtonItem {
    /// True if button is selected, false otherwise
    var isSelected = false {
        didSet {
            title = isSelected ? "Clear all" : "Select all"
        }
    }
}
