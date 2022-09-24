//
//  PinnableScrollView+UIGestureRecognizerDelegate.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 17.11.2020.
//  Copyright © 2020 Denis Bystruev. All rights reserved.
//

import UIKit

extension PinnableScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if
            let tap = gestureRecognizer as? UITapGestureRecognizer,
            let otherTap = otherGestureRecognizer as? UITapGestureRecognizer
        {
            return tap.numberOfTapsRequired < otherTap.numberOfTapsRequired
            
        } else {
            
            return false
        }
    }
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        if
            let tap = gestureRecognizer as? UITapGestureRecognizer,
            let otherTap = otherGestureRecognizer as? UITapGestureRecognizer
        {
            return otherTap.numberOfTapsRequired < tap.numberOfTapsRequired
            
        } else {
            
            return false
        }
    }
}
