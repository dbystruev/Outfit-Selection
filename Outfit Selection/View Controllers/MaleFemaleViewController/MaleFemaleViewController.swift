//
//  MaleFemaleViewController.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class MaleFemaleViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var stackView: UIStackView!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(with: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(with: size)
    }
    
    // MARK: - UI Methods
    func updateUI(with size: CGSize) {
        let isVertical = size.width < size.height
        stackView.axis = isVertical ? .vertical : .horizontal
    }
    
    @IBAction func femaleSelected(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "OutfitSegue", sender: nil)
    }
    
    @IBAction func maleSelected(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "OutfitSegue", sender: nil)
    }
}
