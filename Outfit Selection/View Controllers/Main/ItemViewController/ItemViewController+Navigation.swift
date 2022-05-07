//
//  ItemViewController+Navigation.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 06.05.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension ItemViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ImageViewController.segueIdentifier {
            guard let item = sender as? Item else {
                debug("Can't cast \(String(describing: sender)) to UIImage")
                return
            }
            // Cast ImageViewController and configure it with item
            let imageViewController = segue.destination as? ImageViewController
            imageViewController?.configureImage(item: item)
            
        } else if segue.identifier == "intermediaryViewControllerSegue" {
            let intermediaryViewController = segue.destination as? IntermediaryViewController
            intermediaryViewController?.url = url
        }
    }
}
