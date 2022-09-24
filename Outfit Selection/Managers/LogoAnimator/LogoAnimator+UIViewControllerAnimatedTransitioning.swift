//
//  LogoAnimator+UIViewControllerAnimatedTransitioning.swift
//  Outfit Selection
//
//  Created by Denis Bystruev on 31.01.2021.
//  Copyright © 2021 Denis Bystruev. All rights reserved.
//

import UIKit

extension LogoAnimator: UIViewControllerAnimatedTransitioning {
    /// Returns the duration (in seconds) of the transition animation
    /// - Parameter transitionContext: the context object containing information to use during the transition
    /// - Returns: the duration, in seconds, of custom transition animation
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    /// Performs the transition animations
    /// - Parameter transitionContext: the context object containing information to use during the transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let destination = transitionContext.viewController(forKey: .to) as? GenderViewController else { return }
        guard let destinationLogoImageView = destination.logoImageView else { return }
        guard let destinationView = destination.view else { return }
        guard let source = transitionContext.viewController(forKey: .from) as? LogoViewController else { return }
        guard let sourceDescriptionLabel = source.descriptionLabel else { return }
        guard let sourceLogoImageView = source.logoImageView else { return }
        
        // Add destination view to the transition context and hide it
        let containverView = transitionContext.containerView
        containverView.addSubview(destinationView)
        destinationLogoImageView.isHidden = true
        destinationView.alpha = 0
        let destinationBackgroundColor = destinationView.backgroundColor
        destinationView.backgroundColor = .clear
        
        UIView.animate(withDuration: animationDuration, animations: {
            destinationView.alpha = 1
            sourceDescriptionLabel.alpha = 0
            sourceLogoImageView.frame = destinationLogoImageView.frame
        }) { _ in
            transitionContext.completeTransition(true)
            destination.navigationController?.delegate = nil
            destinationLogoImageView.isHidden = false
            destinationView.backgroundColor = destinationBackgroundColor
            debug("animationDuration =", self.animationDuration)
        }
    }
}
