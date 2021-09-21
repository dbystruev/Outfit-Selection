//
//  UITableViewCell+reuseId.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UITableViewCell {
    // MARK: - Static Properties
    /// ID for use in tableView.dequeueReusableCell(withIdentifier:)
    class var reuseId: String {
        "\(String(describing: Self.self).decapitalizingFirstLetter)ReuseId"
    }
}
