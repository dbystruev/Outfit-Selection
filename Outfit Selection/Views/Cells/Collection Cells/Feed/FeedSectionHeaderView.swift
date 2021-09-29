//
//  FeedSectionHeaderView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedSectionHeaderView: UICollectionReusableView {
    // MARK: - Outlets
    let titleLabel = UILabel()
    
    // MARK: - Stored Properties
    /// Delegate to call when something inside is tapped (for use in child classes)
    var delegate: ButtonDelegate?

    /// Kind of this cell
    var kind: FeedKind = .sale
    
    // MARK: - Computed Properties
    var title: String { kind.title }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }
    
    // MARK: - Custom Methods
    func configureLayout() {
        addSubview(titleLabel)
        
        // Setup constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 24)
        ])
    }
    
    func configureContent(title: String) {
        titleLabel.text = title
    }
}
