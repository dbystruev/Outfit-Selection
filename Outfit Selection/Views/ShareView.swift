//
//  ShareView.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 16.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class ShareView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var outfitBottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var outfitTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var outfitWidthConstraint: NSLayoutConstraint!
    @IBOutlet var pictureImageViews: [UIImageView]!
    
    // MARK: - Class Functions
    class func instanceFromNib() -> ShareView {
        UINib(nibName: "\(Self.self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! Self
    }
    
    // MARK: - Stored Properties
    var items: [Item] = []
    
    // MARK: - Custom Functions
    /// Configure share view with the list of images
    /// - Parameters:
    ///   - images: the list of images — from top to bottom, from left to right
    ///   - items: items corresponding to the images
    func configureContent(with images: [UIImage?], items: [Item]) {
        for (image, pictureImageView) in zip(images, pictureImageViews) {
            pictureImageView.image = image
        }
        self.items = items
    }
    
    /// Configure logo visibility, size and margins for logo and outfit
    /// - Parameters:
    ///   - logoVisible: true if logo should be visible, false otherwise
    ///   - logoHeight: logo height, nil for storyboard value (22)
    ///   - logoTopMargin: logo top margin, nil for storyboard value (73)
    ///   - logoWidth: logo width, nil for storyboard value (114)
    ///   - outfitBottomMargin: outfit bottom margin, nil for storyboard value (87)
    ///   - outfitTopMargin: outfit top margin, nil for storyboard value (142)
    ///   - outfitWidth: outfit width, nil for storyboard value (549)
    func configureLayout(
        logoVisible: Bool,
        logoHeight: CGFloat? = nil,
        logoTopMargin: CGFloat? = nil,
        logoWidth: CGFloat? = nil,
        outfitBottomMargin: CGFloat? = nil,
        outfitTopMargin: CGFloat? = nil,
        outfitWidth: CGFloat? = nil
    ) {
        logoImageView.isHidden = !logoVisible
        if let logoHeight = logoHeight { logoHeightConstraint.constant = logoHeight }
        if let logoTopMargin = logoTopMargin { logoTopMarginConstraint.constant = logoTopMargin }
        if let logoWidth = logoWidth { logoWidthConstraint.constant = logoWidth }
        if let outfitBottomMargin = outfitBottomMargin { outfitBottomMarginConstraint.constant = outfitBottomMargin }
        if let outfitTopMargin = outfitTopMargin { outfitTopMarginConstraint.constant = outfitTopMargin }
        if let outfitWidth = outfitWidth { outfitWidthConstraint.constant = outfitWidth }
    }
}
