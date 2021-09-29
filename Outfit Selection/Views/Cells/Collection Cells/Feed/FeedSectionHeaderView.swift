//
//  FeedSectionHeaderView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedSectionHeaderView: UICollectionReusableView {
    // MARK: - Static Constants
    static let height: CGFloat = 66
    
    // MARK: - Outlets
    let seeAllButton = DelegatedButton()
    let titleLabel = UILabel()
    
    // MARK: - Stored Properties
    /// Delegate to call when something inside is tapped (for use in child classes)
    var delegate: ButtonDelegate?

    /// Kind of this section
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
        // Configure button
        seeAllButton.addTarget(self, action: #selector(seeAllButtonTapped(_:)), for: .touchUpInside)
        seeAllButton.setTitleColor(Globals.Color.Feed.button, for: .normal)
        seeAllButton.titleLabel?.font = Globals.Font.Feed.button
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(seeAllButton)
        
        // Configure title
        titleLabel.textColor = Globals.Color.Feed.header
        titleLabel.font = Globals.Font.Feed.header
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            seeAllButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 24),
            seeAllButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -24),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 24)
        ])
    }
    
    func configureContent(kind: FeedKind) {
        seeAllButton.setTitle("See all", for: .normal)
        seeAllButton.isHidden = kind == .brands
        titleLabel.text = kind.title
    }
    
    // MARK: - Actions
    @objc func seeAllButtonTapped(_ sender: DelegatedButton) {
        debug(self)
        delegate?.buttonTapped(self)
    }
}
