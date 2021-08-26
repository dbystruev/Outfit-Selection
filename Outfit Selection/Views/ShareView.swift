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
    
    // MARK: - Type enum
    enum ShareType: String, CaseIterable {
        case instagramStories = "Instagram Stories"
        case instagramPost = "Instagram Post"
        case pinterest
        case telegram
        case whatsApp
        case facebook
        case copyLink = "Copy Link"
        case more
    }
    
    // MARK: - Class Properties
    /// Nib name is the same as the class name
    class var nibName: String { String(describing: Self.self) }
    
    // MARK: - Static Properties
    /// The nib object containing this share view
    static let nib = UINib(nibName: nibName, bundle: nil)
    
    // MARK: - Class Functions
    class func instanceFromNib() -> ShareView {
        nib.instantiate(withOwner: nil, options: nil)[0] as! Self
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
    
    /// Configure logo visibility, size and margins depending on type of share
    /// - Parameter type: type of share to configure the view for
    func configureLayout(for type: ShareView.ShareType) {
        switch type {
        
        case .instagramStories: configureLayout(frameWidth: 1080,
                                                frameHeight: 1920,
                                                logoVisible: true,
                                                logoHeight: 38,
                                                logoTopMargin: 282,
                                                logoWidth: 196,
                                                outfitBottomMargin: 283,
                                                outfitTopMargin: 373,
                                                outfitWidth: 854)
            
        case .instagramPost: configureLayout(frameWidth: 1080,
                                             frameHeight: 1080,
                                             logoVisible: true,
                                             logoHeight: 22,
                                             logoTopMargin: 73,
                                             logoWidth: 114,
                                             outfitBottomMargin: 74,
                                             outfitTopMargin: 142,
                                             outfitWidth: 549)
            
        case .pinterest: configureLayout(frameWidth: 800,
                                         frameHeight: 1200,
                                         logoVisible: true,
                                         logoHeight: 28,
                                         logoTopMargin: 97,
                                         logoWidth: 142,
                                         outfitBottomMargin: 97,
                                         outfitTopMargin: 178,
                                         outfitWidth: 624)
            
        case .facebook: configureLayout(frameWidth: 1200,
                                        frameHeight: 630,
                                        logoVisible: true,
                                        logoHeight: 22,
                                        logoTopMargin: 50,
                                        logoWidth: 95,
                                        outfitBottomMargin: 51,
                                        outfitTopMargin: 125,
                                        outfitWidth: 306)
            
        default: configureLayout(logoVisible: true)
        }
    }
    
    /// Configure logo visibility, size and margins for logo and outfit
    /// - Parameters:
    ///   - frameWidth: frame width, nil for storyboard value (1080)
    ///   - frameHeight: frame height, nil for storyboard value (1080)
    ///   - logoVisible: true if logo should be visible, false otherwise
    ///   - logoHeight: logo height, nil for storyboard value (22)
    ///   - logoTopMargin: logo top margin, nil for storyboard value (73)
    ///   - logoWidth: logo width, nil for storyboard value (114)
    ///   - outfitBottomMargin: outfit bottom margin, nil for storyboard value (87)
    ///   - outfitTopMargin: outfit top margin, nil for storyboard value (142)
    ///   - outfitWidth: outfit width, nil for storyboard value (549)
    func configureLayout(
        frameWidth: CGFloat? = nil,
        frameHeight: CGFloat? = nil,
        logoVisible: Bool,
        logoHeight: CGFloat? = nil,
        logoTopMargin: CGFloat? = nil,
        logoWidth: CGFloat? = nil,
        outfitBottomMargin: CGFloat? = nil,
        outfitTopMargin: CGFloat? = nil,
        outfitWidth: CGFloat? = nil
    ) {
        logoImageView.isHidden = !logoVisible
        if let frameWidth = frameWidth { frame.size.width = frameWidth }
        if let frameHeight = frameHeight { frame.size.height = frameHeight }
        if let logoHeight = logoHeight { logoHeightConstraint.constant = logoHeight }
        if let logoTopMargin = logoTopMargin { logoTopMarginConstraint.constant = logoTopMargin }
        if let logoWidth = logoWidth { logoWidthConstraint.constant = logoWidth }
        if let outfitBottomMargin = outfitBottomMargin { outfitBottomMarginConstraint.constant = outfitBottomMargin }
        if let outfitTopMargin = outfitTopMargin { outfitTopMarginConstraint.constant = outfitTopMargin }
        if let outfitWidth = outfitWidth { outfitWidthConstraint.constant = outfitWidth }
    }
    
    /// Create a copy of existing share view and configure it for given share type
    /// - Parameter type: type of share to configure the view for
    /// - Returns: copy of existing share view configured for given share type
    func layout(for type: ShareView.ShareType) -> ShareView {
        // Create new share view
        let newShareView = ShareView.instanceFromNib()
        
        // Configure new share view layout
        newShareView.configureLayout(for: type)
        
        // Configure new share view content
        newShareView.configureContent(with: pictureImageViews.map { $0.image }, items: items)
        
        return newShareView
    }
    
    /// Create a copy of existing share view
    /// - Parameters:
    ///   - frameWidth: frame width, nil for storyboard value (1080)
    ///   - frameHeight: frame height, nil for storyboard value (1080)
    ///   - logoVisible: true if logo should be visible, false otherwise
    ///   - logoHeight: logo height, nil for storyboard value (22)
    ///   - logoTopMargin: logo top margin, nil for storyboard value (73)
    ///   - logoWidth: logo width, nil for storyboard value (114)
    ///   - outfitBottomMargin: outfit bottom margin, nil for storyboard value (87)
    ///   - outfitTopMargin: outfit top margin, nil for storyboard value (142)
    ///   - outfitWidth: outfit width, nil for storyboard value (549)
    /// - Returns: copy of existing share view with new layout
    func layout(
        frameWidth: CGFloat? = nil,
        frameHeight: CGFloat? = nil,
        logoVisible: Bool,
        logoHeight: CGFloat? = nil,
        logoTopMargin: CGFloat? = nil,
        logoWidth: CGFloat? = nil,
        outfitBottomMargin: CGFloat? = nil,
        outfitTopMargin: CGFloat? = nil,
        outfitWidth: CGFloat? = nil
    ) -> ShareView {
        // Create new share view
        let newShareView = ShareView.instanceFromNib()
        
        // Configure new share view layout
        newShareView.configureLayout(frameWidth: frameWidth,
                                     frameHeight: frameHeight,
                                     logoVisible: logoVisible,
                                     logoHeight: logoHeight,
                                     logoTopMargin: logoTopMargin,
                                     logoWidth: logoWidth,
                                     outfitBottomMargin: outfitBottomMargin,
                                     outfitTopMargin: outfitTopMargin,
                                     outfitWidth: outfitWidth)
        
        // Configure new share view content
        newShareView.configureContent(with: pictureImageViews.map { $0.image }, items: items)
        
        return newShareView
    }
}
