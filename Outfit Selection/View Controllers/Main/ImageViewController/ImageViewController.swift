//
//  ImageViewController.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 06.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

class ImageViewController: LoggableViewController {
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    // MARK: - Private Properties
    // First item image
    private var image: UIImage?
    
    // MARK: - Properties
    // Changed when call dooble tap
    var tapped = true
    
    let minimumZoomScale = 1.0
    let maximumZoomScale = 3.0
    let zoomScale = 1.0
    
    // MARK: - Methods
    /// Configure imageView
    func configureImage(item: Item) {
        guard let imageURL = item.pictures.first else {
            debug("ERROR: Item", item, "has no pictures")
            return
        }
        // Get images from item
        NetworkManager.shared.getImage(imageURL) { image in
            // Wait for image downloaded
            guard let image = image else { return }
            self.image = image
            DispatchQueue.main.async {
                self.imageView?.image = image
            }
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UIScrollView
        imageScrollView.minimumZoomScale = minimumZoomScale
        imageScrollView.maximumZoomScale = maximumZoomScale
        imageScrollView.zoomScale = zoomScale
        imageScrollView.delegate = self
        
        // Configure UITapGestureRecognizer for double tap
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        imageView.isUserInteractionEnabled = true
        tap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tap)
    }
}
