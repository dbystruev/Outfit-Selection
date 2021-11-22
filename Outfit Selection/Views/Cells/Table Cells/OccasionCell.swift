//
//  OccasionCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var occasionNameLabel: UILabel!
    
    // MARK: - Static Constants
    static let heigth: CGFloat = UITableView.automaticDimension // 40
    
    // MARK: - Inherited Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }

    // MARK: - Custom Methods
    /// Configures this cell with a given occasion
    /// - Parameter occasion: the occasion to configure this cell with
    func configureContent(with occasion: Occasion) {
        debug(occasion.title, "\(occasion.isSelected ? "" : "de")selected")
        checkBoxImageView.isHighlighted = occasion.isSelected
        occasionNameLabel.text = occasion.title
    }
    
    /// Configure the cell's look and feel once at the beginning
    func configureLayout() {
        selectionStyle = .none
    }

}
