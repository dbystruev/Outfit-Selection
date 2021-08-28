//
//  UIViewContentMode+CustomStringConvertible.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 28.08.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension UIView.ContentMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bottom:
            return ".bottom"
        case .bottomLeft:
            return ".bottomLeft"
        case .bottomRight:
            return ".bottomRight"
        case .center:
            return ".center"
        case .left:
            return ".left"
        case .redraw:
            return ".redraw"
        case .right:
            return ".right"
        case .scaleAspectFit:
            return ".scaleAspectFit"
        case .scaleAspectFill:
            return ".scaleAspectFill"
        case .scaleToFill:
            return ".scaleToFill"
        case .top:
            return ".top"
        case .topLeft:
            return ".topLeft"
        case .topRight:
            return ".topRight"
        @unknown default:
            return "\(rawValue)"
        }
    }
}
