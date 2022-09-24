//
//  Bubble.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 24.03.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

class Bubble: UIView {
    // MARK: - Stored Properties
    let cornerRadius: CGFloat = 15
    
    /// The color used to fill the shape's path
    let fillColor = #colorLiteral(red: 0.4727200866, green: 0.5382744074, blue: 0.5183323622, alpha: 1)
    
    /// Hardcoded height to calculate scale when needed
    let height: CGFloat = 58
    
    /// Bubble label to show text
    let label = UILabel()
    
    /// The line width of the shape’s path
    let lineWidth: CGFloat = 1
    
    /// The color used to stroke the shape's path
    let strokeColor = #colorLiteral(red: 0.4727200866, green: 0.5382744074, blue: 0.5183323622, alpha: 1)
    
    /// Hardcoded width to calculate scale when needed
    let width: CGFloat = 238
    
    // MARK: - Computed Properties
    /// Generate Bezier path for the refresh bubble with hardcoded height and width above
    /// - Returns: the bezier path for the refresh bubble
    var bezierPath: UIBezierPath {
        // Main buble
        let bubble = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width - 4, height: height), cornerRadius: cornerRadius)
        
        return bubble
    }
    
    /// Label font
    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }
    
    /// Label text
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    /// Label text color
    var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Custom Methods
    /// Adds bezier path to CAShapeLayer when the view is initialized
    /// https://stackoverflow.com/a/34659468/7851379
    func configure() {
        // Create a shape layer
        let shapeLayer = CAShapeLayer()
        
        // Use Bezier path
        shapeLayer.path = bezierPath.cgPath
        
        // Setup properties
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = strokeColor.cgColor
        
        // Add the layer to the view
        layer.addSublayer(shapeLayer)
        
        // Configure label
        font = UIFont(name: "NotoSans-Regular", size: 17)!
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.textAlignment = .center
        textColor = .white
        addSubview(label)
    }
}
