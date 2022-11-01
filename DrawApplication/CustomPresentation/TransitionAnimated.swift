//
//  TransitionAnimated.swift
//  CustomPresentation
//
//  Created by Рамил Гаджиев on 11.09.2022.
//

import UIKit

class TransitionAnimated: NSObject {
    
    let duration: TimeInterval
    var transitionDirection: PopoverDirection
    
    init(duration: TimeInterval, transitionDirection: PopoverDirection) {
        self.duration = duration
        self.transitionDirection = transitionDirection
        super.init()
    }
    
    /// need to override
    func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)
        
        return animator
    }
    
    final func offsetBy(with frame: CGRect) -> (dx: CGFloat, dy: CGFloat) {
        switch transitionDirection {
        case .fromBottom:
            return (0, frame.height)
        case .fromTop:
            return (0, -frame.height)
        case .fromLeft:
            return (-frame.width, 0)
        case .fromRight:
            return (frame.width, 0)
        }
    }
}

extension TransitionAnimated: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
