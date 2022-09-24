//
//  Corner.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 29.10.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

/// One of 5 outfit corners
enum Corner: Int, CaseIterable {
    // Cases listed in order of API occasions corner
    case topLeft = 0
    case topRight
    case middleRight
    case bottomRight
    case bottomLeft
}
