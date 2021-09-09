//
//  OccasionCell.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 09.09.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class OccasionCell: UITableViewCell {

    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var occasionNameLabel: UILabel!
    
    // MARK: - Inherited Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Custom Methods
    /// Configures this cell with a given occasion
    /// - Parameter occasion: the occasion to configure this cell with
    func configure(with occasion: Occasion) {
        checkBoxImageView.isHighlighted = occasion.isSelected
        occasionNameLabel.text = occasion.name
    }

}
