//
//  DismissAnimation.swift
//  CustomPresentation
//
//  Created by Рамил Гаджиев on 11.09.2022.
//

import UIKit

class DismissAnimation: TransitionAnimated {
    
    override func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let from = transitionContext.view(forKey: .from)!
        let initialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: .from)!)
        let offset = offsetBy(with: initialFrame)

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            from.frame = initialFrame.offsetBy(dx: offset.dx, dy: offset.dy)
        }

        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
    
}
