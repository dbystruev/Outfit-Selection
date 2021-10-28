//
//  OutfitViewController+Shake.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension OutfitViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        switch motion {
        case .motionShake:
            if let occasion = occasionSelected {
                // Get unique subcategory IDs for occasion
                debug(occasion.corners.map { $0.compactMap { Categories.byID[$0] }})
                
                // Go through each item and show its subcategory in occasion
                for item in visibleItems {
                    debug(item.name, item.subcategories(in: occasion))
                }
            }
        default:
            break
        }
    }
}
