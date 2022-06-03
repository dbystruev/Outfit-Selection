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
    static var height: CGFloat = 110
    
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
    
    // MARK: - Stored Properties
    /// Delegate to call when something inside is tapped (for use in child classes)
    var delegate: ButtonDelegate?
    
    /// Identificator collection
    var id: String?
    
    /// Index of collection view section
    var indexSection: Int = 0
    
    /// Empty pick
    var pick: Pick = Pick(.hello, title: "")
    
    // MARK: - Computed Properties
    var title: String? { pick.title }
    
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
        titleLabel.numberOfLines = 0
        titleLabel.textColor = Global.Color.Feed.header
        titleLabel.font = Global.Font.Feed.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            seeAllButton.leadingAnchor.constraint(
                greaterThanOrEqualTo: header.trailingAnchor, constant: 16
            ),
            header.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
            header.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            header.trailingAnchor.constraint(lessThanOrEqualTo: seeAllButton.leadingAnchor),
            seeAllButton.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            seeAllButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -24),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: seeAllButton.leadingAnchor),
        ])
    }
    
    func configureContent(kind: PickType, indexSection: Int, id: String) {
        self.pick = Pick(kind, title: kind.title ?? "")
        seeAllButton.setTitle("See all"~, for: .normal)
        seeAllButton.isHidden = kind == .brands || kind == .emptyBrands || kind == .hello
        header.text = kind.title
        self.id = id
        self.indexSection = indexSection
    }
    
    func configureContent(pick: Pick) {
        self.pick = pick
        
        header.text = pick.title
        
        titleLabel.isHidden = pick.subtitles.isEmpty
        titleLabel.text = pick.subtitles.joined(separator: "\n")
        
        let shouldHide = pick.limit == 0
        seeAllButton.isHidden = shouldHide
        seeAllButton.setContentCompressionResistancePriority(UILayoutPriority(shouldHide ? 0 : 1000), for: .horizontal)
        seeAllButton.setTitle("See all"~, for: .normal)
    }
    
    // MARK: - Actions
    @objc func seeAllButtonTapped(_ sender: DelegatedButton) {
        delegate?.buttonTapped(self)
    }
}
