//
//  OutfitViewController+present.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - MaleFemale
extension OutfitViewController {
    /// Instantiate and present brands view controller
    func presentBrandsViewController() {
        presentViewController(withIdentifier: "BrandsViewController", style: .formSheet)
    }
    
    /// Instantiate and present male female view controller
    func presentMaleFemaleViewController() {
        presentViewController(withIdentifier: "MaleFemaleController", style: .formSheet)
    }
    
    /// Instantiate and present view controller with given identifier and style
    /// - Parameters:
    ///   - identifier: storyboard identifier of view controller
    ///   - style: modal presentation style for view controller
    func presentViewController(withIdentifier identifier: String, style: UIModalPresentationStyle) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        viewController.modalPresentationStyle = style
        viewController.popoverPresentationController?.sourceView = view
        OperationQueue.main.addOperation {
            self.present(viewController, animated: true)
        }
    }
}
