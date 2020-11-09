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
    
    // MARK: - Methods
    func updateMainViewController(with gender: Gender) {
        guard let navigationController = presentingViewController as? UINavigationController else { return }
        
        guard let outfitViewController = navigationController.viewControllers.first as? OutfitViewController else {
            return
        }
        
        outfitViewController.gender = gender
    }
    
    // MARK: - UIViewController Methods    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let navigationController = presentingViewController as? UINavigationController else { return }
        
//        NetworkManager.shared.getCategories { categories in
//            guard let categories = categories?.sorted(by: { $0.name < $1.name }) else { return }
//            print("\(#line) \(Self.self).\(#function) categories.count = \(categories.count)")
//            categories.forEach { print("\t\($0)") }
//        }
        
        for category in Category.all {
            DispatchManager.shared.group.enter()
            
            NetworkManager.shared.getOffers(in: category) { offers in
                DispatchManager.shared.group.leave()
                
                guard let offers = offers else { return }
                Offer.all.append(contentsOf: offers)
//                print("\(#line) \(Self.self).\(#function) category: \(category.name), offers.count = \(offers.count)")
//                offers.forEach { print("\t\($0)") }
            }
        }
        
        DispatchManager.shared.group.notify(queue: .main) {
//            print("\(#line) \(Self.self).\(#function) Offer.all.count = \(Offer.all.count)")
            
            guard Offer.maxCount * (Category.all.count - 1) < Offer.all.count else { return }
            guard let controller = navigationController.viewControllers.first as? OutfitViewController else { return }
            
            controller.loadImagesFromServer()
        }
        
        updateUI(with: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(with: size)
    }
    
    func updateUI(with size: CGSize) {
        let isVertical = size.width < size.height
        stackView.axis = isVertical ? .vertical : .horizontal
    }
    
    // MARK: - Actions
    @IBAction func femaleSelected(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
        updateMainViewController(with: .female)
    }
    
    @IBAction func maleSelected(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
        updateMainViewController(with: .male)
    }
}
