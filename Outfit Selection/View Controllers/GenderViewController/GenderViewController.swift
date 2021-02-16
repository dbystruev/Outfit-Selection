//
//  GenderViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31/07/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

class GenderViewController: UIViewController {
    
    // MARK: - Outlets
    /// Gender selection buttons stack view
    @IBOutlet weak var buttonStackView: UIStackView!
    
    /// Label with text "Get Outfit is a personalised styling platform"
    @IBOutlet weak var descriptionLabel: UILabel!
    
    /// Final position of Get Outfit logo
    @IBOutlet weak var logoImageView: UIImageView!
    
    /// Initial position of Get Outfit logo
    @IBOutlet weak var startingLogoImageView: UIImageView!
    
    // MARK: - Inherited Computed Properties
    // MARK: - Stored Properties
    /// Flag which indicates if this is the first appearance of this view controller (true) or we came back from navigation stack (false)
    var firstAppearance = true
    
    /// Gender selected by user
    var gender = Gender.other
    
    // MARK: - Methods
    /// Performs segue to brands view controller
    /// - Parameter sender: the object which caused the segue
    func performSegueToBrandsViewController(sender: Any?) {
        // Show navigation bar on top
        navigationController?.navigationBar.isHidden = false
        
        performSegue(withIdentifier: "BrandsViewControllerSegue", sender: sender)
    }
    
    // MARK: - Inherited Methods
    /// Passes gender information to the brands view controller
    /// - Parameters:
    ///   - segue: the segue with information about the view controllers involved in the segue
    ///   - sender: the object that initiated the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "BrandsViewControllerSegue" else { return }
        guard let destination = segue.destination as? BrandsViewController else { return }
        destination.gender = gender
    }
    
    /// Hides toolbar and navigation bar before the view is added to a view hierarchy
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide toolbar at the bottom
        navigationController?.isToolbarHidden = true
        
        // Make navigation controller bar style dark in order for status bar to become light
        navigationController?.navigationBar.barStyle = .black
        
        // Hide navigation bar on top
        navigationController?.navigationBar.isHidden = true
    }
    
    /// Return navigation controller bar style back to normal
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    /// Animate logo to the new position, hide description and unhide button stack view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Animate only if we came from logo screen
        guard firstAppearance else { return }
        
        firstAppearance = false
        
        // Animate logo image view shift and description label fading
        UIView.animate(withDuration: 1) {
            self.descriptionLabel.alpha = 0
            self.startingLogoImageView.frame = self.logoImageView.frame
        } completion: { _ in
            // Hide outlets from the logo screen
            self.descriptionLabel.isHidden = true
            self.startingLogoImageView.isHidden = true
            
            // Show outlets at the gender screen
            self.buttonStackView.alpha = 0
            self.buttonStackView.isHidden = false
            self.logoImageView.isHidden = false
            
            // Animate button stack view unfading
            UIView.animate(withDuration: 1) {
                self.buttonStackView.alpha = 1
            }
        }
        
    }
    
    // MARK: - Actions
    /// Called when the female button is tapped
    /// - Parameter sender: the gesture recognizer which was tapped
    @IBAction func femaleSelected(_ sender: GenderButton) {
        gender = .female
        performSegueToBrandsViewController(sender: sender)
    }
    
    /// Called when the male button is tapped
    /// - Parameter sender: the gesture recognizer which was tapped
    @IBAction func maleSelected(_ sender: GenderButton) {
        gender = .male
        performSegueToBrandsViewController(sender: sender)
    }
    
    @IBAction func otherSelected(_ sender: GenderButton) {
        gender = .other
        performSegueToBrandsViewController(sender: sender)
    }
}
