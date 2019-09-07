//
//  OutfitViewController+Shake.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

extension OutfitViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        switch motion {
        case .motionShake:
            shuffle()
        default:
            break
        }
    }
    
    func shuffle() {
        setEditing(false, animated: true)
        scrollViews.forEach {
            if !$0.isPinned {
                $0.scrollToRandomElement()
            }
        }
    }
}
