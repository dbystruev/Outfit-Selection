//
//  FeedBaseCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 26.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class FeedBaseCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Class Properties
    class var designFactor: CGFloat { 1.25 }
    
    /// Default cell's height
    class var height: CGFloat { 282 * designFactor }

    /// Feed cell identifier, which matches nib and class name
    class var identifier: String { nibName }
    
    /// The nib object containing this feed item cell
    class var nib: UINib { UINib(nibName: nibName, bundle: nil) }
    
    /// Nib name is the same as the class name
    class var nibName: String { String(describing: Self.self) }
    
    /// Default item sizes
    class var itemHeight: CGFloat { 206 * designFactor }
    class var itemWidth: CGFloat { 120 * designFactor }

    // MARK: - Class Methods
    /// Registers the cell with the table view
    /// - Parameter tableView: the table view to register with
    /// - Returns: (optional) returns cell identifier, also available as MessageListCell.identifier
    @discardableResult class func register(with tableView: UITableView?) -> String {
        tableView?.register(nib, forCellReuseIdentifier: identifier)
        return identifier
    }
    
    // MARK: - Stored Properties
    /// Delegate to call when something inside is tapped (for use in child classes)
    var delegate: ButtonDelegate?

    /// Kind of this cell
    var kind: FeedKind = .sale
    
    // MARK: - Computed Properties
    var title: String? { kind.title }
    
    // MARK: - Inherited Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    // MARK: - Custom Methods
    /// Called from awakeFromNib() in the beggining, when we don't know yet what to display
    func configureLayout() {
        // No selection style be default
        selectionStyle = .none
    }
}
