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
    static let height: CGFloat = 80
    
    // MARK: - Class Methods
    /// Registers the header view with the collection view
    /// - Parameter collectionView: the collection view to register with
    /// - Returns: (optional) returns cell identifier
    @discardableResult class func register(with collectionView: UICollectionView?) -> String {
        collectionView?.register(
            Self.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: reuseId
        )
        return reuseId
    }
    
    // MARK: - Outlets
    let seeAllButton = DelegatedButton()
    let header = UILabel()
    let titleLabel = UILabel()
    let subtitle = UILabel()
    
    // MARK: - Stored Properties
    /// Delegate to call when something inside is tapped (for use in child classes)
    var delegate: ButtonDelegate?

    /// Kind of this section
    var kind: PickType = .sale
    
    // MARK: - Computed Properties
    var title: String? { kind.title }
    
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
        seeAllButton.setTitleColor(Global.Color.Feed.button, for: .normal)
        seeAllButton.titleLabel?.font = Global.Font.Feed.button
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(seeAllButton)
        
        // Configure header
        header.numberOfLines = 2
        header.textColor = Global.Color.Feed.header
        header.font = Global.Font.Feed.header
        header.translatesAutoresizingMaskIntoConstraints = false
        addSubview(header)
        
        // Configure title
        titleLabel.numberOfLines = 2
        titleLabel.textColor = Global.Color.Feed.header
        titleLabel.font = Global.Font.Feed.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Configure subtitle
        subtitle.numberOfLines = 2
        subtitle.textColor = Global.Color.Feed.header
        subtitle.font = Global.Font.Feed.button
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subtitle)
        
        
        // Setup constraints
        NSLayoutConstraint.activate([
            seeAllButton.leadingAnchor.constraint(
                greaterThanOrEqualTo: header.trailingAnchor, constant: 16
            ),
            seeAllButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 24),
            seeAllButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -24),
            header.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            header.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: 24),
            subtitle.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            subtitle.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24)
        ])
    }
    
    func configureContent(kind: PickType) {
        self.kind = kind
        seeAllButton.setTitle("See all"~, for: .normal)
        seeAllButton.isHidden = kind == .brands || kind == .emptyBrands || kind == .hello
        header.text = kind.title
        titleLabel.isHidden = kind == .brands || kind == .emptyBrands
        titleLabel.text = kind.subtitle?.first
        subtitle.isHidden = kind != .hello
        subtitle.text = kind.subtitle?.last
        
    }
    
    // MARK: - Actions
    @objc func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(self)
    }
}
