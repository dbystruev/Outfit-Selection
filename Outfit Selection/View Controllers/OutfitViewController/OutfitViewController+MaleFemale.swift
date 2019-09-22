//
//  OutfitViewController+MaleFemale.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

// MARK: - MaleFemale
extension OutfitViewController {
    func presentMaleFemaleViewController(style: UIModalPresentationStyle) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let maleFemaleController = storyboard.instantiateViewController(withIdentifier: "MaleFemaleController")
        maleFemaleController.modalPresentationStyle = style
        maleFemaleController.popoverPresentationController?.sourceView = view
        OperationQueue.main.addOperation {
            self.present(maleFemaleController, animated: true)
        }
    }
}
