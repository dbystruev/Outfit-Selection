//
//  ProgressViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.02.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit
import Firebase

class ProgressViewController: LoggingViewController {
    
    // MARK: - Outlets
    /// Logo on top of progress bar
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            logoImageView.image = UIImage(named: WhiteLabel.logo)
        }
    }
    
    /// Text `picking up the right pieces` above the progress bar
    @IBOutlet weak var progressLabel: UILabel! {
        didSet {
            progressLabel.textColor = WhiteLabel.Color.Text.label
        }
    }
    
    /// The actual progress bar
    @IBOutlet weak var progressView: UIProgressView! {
        didSet {
            progressView.progressTintColor = WhiteLabel.Color.Progress.progressTintColor
            progressView.trackTintColor = WhiteLabel.Color.Progress.trackTintColor
        }
    }
    
    // MARK: - Static Properties
    /// Link to self for others to find
    static weak var `default`: ProgressViewController?
    
    // MARK: - Stored Properties
    /// Switch to tab bar index after the move to tab bar view controller
    var selectedTabBarIndex = 0
    
    // MARK: - Inherited Properties
    /// Hide status bar during progress screen
    override var prefersStatusBarHidden: Bool { true }
    
    // MARK: - Methods
    /// Update progress bar in main dispatch queue
    /// - Parameters:
    ///   - current: number of items processed
    ///   - total: total number of items to process
    ///   - minValue: the minimum value where indicator should start, from 0 to 1, 0 by default
    ///   - maxValue: the maximum value where indicator should end, from 0 to 1, 1 by default
    func updateProgressBar(current: Int, total: Int, minValue: Float = 0, maxValue: Float = 1) {
        // Get value as current fraction of total value
        let value = total == 0 ? 0 : Float(current) / Float(total)
        
        // Update progress view
        DispatchQueue.main.async {
            self.progressView.progress = minValue + (maxValue - minValue) * value
        }
    }
    
    // MARK: - Inherited Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make sure others can find ourselves
        ProgressViewController.default = self
        
        view.backgroundColor = WhiteLabel.Color.Background.light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start navigation manager and load OutfitViewController
        NavigationManager.navigate(to: .outfit())
    }
    
}
