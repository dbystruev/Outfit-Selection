//
//  ProfileSectionHeaderView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ProfileSectionHeaderView: UICollectionReusableView {
    // MARK: - Static Properties
    /// The nib object containing this section header
    static let nib = UINib(nibName: className, bundle: nil)
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Methods
    /// Configure the section header with a given title
    /// - Parameter title: the title to configure the section header with
    func configure(title: String) {
        titleLabel.text = title
    }
}
