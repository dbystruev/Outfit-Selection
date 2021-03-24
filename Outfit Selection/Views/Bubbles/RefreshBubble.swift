//
//  RefreshBubble.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class RefreshBubble: Bubble {
    // MARK: - Computed Properties
    /// Generate Bezier path for the refresh bubble with hardcoded height and width above
    /// - Returns: the bezier path for the refresh bubble
    override var bezierPath: UIBezierPath {
        // Using https://swiftvg.mike-engel.com to generate
        
        // Main buble
        let bubble = super.bezierPath
        
        // Right tail
        let tail = UIBezierPath()
        tail.move(to: CGPoint(x: 229.61, y: 20.29))
        tail.addLine(to: CGPoint(x: 222, y: 33.25))
        tail.addCurve(to: CGPoint(x: 241.16, y: 28.26), controlPoint1: CGPoint(x: 228.67, y: 37.16), controlPoint2: CGPoint(x: 237.25, y: 34.93))
        tail.addLine(to: CGPoint(x: 244.2, y: 23.09))
        tail.addLine(to: CGPoint(x: 243.91, y: 22.92))
        tail.addCurve(to: CGPoint(x: 238.39, y: 23.7), controlPoint1: CGPoint(x: 242.15, y: 23.55), controlPoint2: CGPoint(x: 240.28, y: 23.82))
        tail.addCurve(to: CGPoint(x: 229.61, y: 20.29), controlPoint1: CGPoint(x: 235.92, y: 23.56), controlPoint2: CGPoint(x: 233.44, y: 22.45))
        tail.close()
        
        bubble.append(tail.reversing())
        
        return bubble
    }
}
