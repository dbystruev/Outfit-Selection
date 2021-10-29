//
//  OutfitViewController+Shake.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 07/09/2019.
//  Copyright © 2019–2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension OutfitViewController {
    /// Process shake motion
    /// - Parameters:
    ///   - motion: the motion which happened
    ///   - event: the UI event associated with the motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        switch motion {
            
        case .motionShake:
            showLookDetails()
            
        default:
            break
        }
    }
}
