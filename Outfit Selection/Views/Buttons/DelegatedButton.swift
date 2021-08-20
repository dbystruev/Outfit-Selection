//
//  DelegatedButton.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 20.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

/// UIButton which has a button delegate property
class DelegatedButton: UIButton {
    /// Button delegate property with buttonPressed(_:) function
    var delegate: ButtonDelegate?
}
