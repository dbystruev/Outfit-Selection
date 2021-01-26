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
    @IBOutlet weak var getOutfitLogo: UIImageView!
    
    // MARK: - Properties
    /// Gender selected by user
    var gender = Gender.other {
        didSet {
            guard oldValue != gender else { return }
            guard let navigationController = presentingViewController as? UINavigationController else { return }
            guard let outfitViewController = navigationController.viewControllers.first as? OutfitViewController else { return }
            Item.removeAll()
            outfitViewController.gender = gender
        }
    }
    
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
    
    /// Configures layout after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide toolbar at the bottom
        navigationController?.isToolbarHidden = true
    }
    
    /// Hides navigation bar before the view is added to a view hierarchy
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar on top
        navigationController?.navigationBar.isHidden = true
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
