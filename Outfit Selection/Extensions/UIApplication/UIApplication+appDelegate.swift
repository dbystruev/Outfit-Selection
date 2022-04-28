//
//  UIApplication+appDelegate.swift
//  Outfit Selection
//
//  Created by Evgeniy Goncharov on 28.04.2022.
//  Copyright © 2022 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIApplication {
    static var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
}
