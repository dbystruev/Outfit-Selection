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
    /// Stack view with female and male icons
    @IBOutlet var genderStackView: UIStackView!
    
    // MARK: - Properties
    /// Gender selected by user
    var gender = Gender.other {
        didSet {
            guard let navigationController = presentingViewController as? UINavigationController else { return }
            guard let outfitViewController = navigationController.viewControllers.first as? OutfitViewController else { return }
            outfitViewController.gender = gender
        }
    }
    
    // MARK: - Methods
    /// Make gender stack view horizontal or vertical depending on screen size and orientation
    /// - Parameter size: size of the view where gender stack view is present
    func configureLayout(with size: CGSize) {
        let isVertical = size.width < size.height
        genderStackView.axis = isVertical ? .vertical : .horizontal
    }
    
    /// Performs segue to brands view controller
    /// - Parameter sender: the object which caused the segue
    func performSegueToBrandsViewController(sender: Any?) {
        performSegue(withIdentifier: "BrandsViewController", sender: sender)
    }
    
    // MARK: - UIViewController Methods
    /// Passes gender information to the brands view controller
    /// - Parameters:
    ///   - segue: the segue with information about the view controllers involved in the segue
    ///   - sender: the object that initiated the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "BrandsViewController" else { return }
        guard let destination = segue.destination as? BrandsViewController else { return }
        destination.gender = gender
    }
    
    /// Configure layout after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout(with: view.bounds.size)
    }
    
    /// Calls configuration of gender stack view layout to the new size to which the view is about to change.
    /// - Parameters:
    ///   - size: the new size for the view
    ///   - coordinator: the transition coordinator object managing the size change for passing to super
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        configureLayout(with: size)
    }
    
    // MARK: - Actions
    /// Called when the female button is tapped
    /// - Parameter sender: the gesture recognizer which was tapped
    @IBAction func femaleSelected(_ sender: UITapGestureRecognizer) {
        gender = .female
        performSegueToBrandsViewController(sender: sender)
    }
    
    /// Called when the male button is tapped
    /// - Parameter sender: the gesture recognizer which was tapped
    @IBAction func maleSelected(_ sender: UITapGestureRecognizer) {
        gender = .male
        performSegueToBrandsViewController(sender: sender)
    }
}
