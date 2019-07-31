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
    func presentMaleFemaleSelection() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let maleFemaleController = storyboard.instantiateViewController(withIdentifier: "MaleFemaleController")
        maleFemaleController.modalPresentationStyle = .popover
        present(maleFemaleController, animated: true)
    }
}
