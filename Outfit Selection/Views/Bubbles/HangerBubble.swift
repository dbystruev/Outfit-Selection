//
//  HangerBubble.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class HangerBubble: Bubble {
    override var bezierPath: UIBezierPath {
        // Using https://swiftvg.mike-engel.com to generate
        
        // Main bubble
        let bubble = super.bezierPath
        
        // Right tail down
        let tail = UIBezierPath()
        tail.move(to: CGPoint(x: 231.7, y: 19.85))
        tail.addLine(to: CGPoint(x: 217, y: 25.53))
        tail.addCurve(to: CGPoint(x: 236.4, y: 34.12), controlPoint1: CGPoint(x: 219.99, y: 33.26), controlPoint2: CGPoint(x: 228.67, y: 37.1))
        tail.addLine(to: CGPoint(x: 241.9, y: 31.99))
        tail.addCurve(to: CGPoint(x: 236.91, y: 29.11), controlPoint1: CGPoint(x: 240.06, y: 31.39), controlPoint2: CGPoint(x: 238.36, y: 30.41))
        tail.addCurve(to: CGPoint(x: 231.7, y: 19.85), controlPoint1: CGPoint(x: 234.9, y: 27.31), controlPoint2: CGPoint(x: 233.6, y: 24.61))
        tail.close()
        
        bubble.append(tail.reversing())
        
        return bubble
    }
}
