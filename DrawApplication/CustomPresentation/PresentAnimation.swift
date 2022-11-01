//
//  PresentAnimation.swift
//  CustomPresentation
//
//  Created by Рамил Гаджиев on 11.09.2022.
//

import UIKit

class PresentAnimation: TransitionAnimated {
    
    override func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        // transitionContext.view содержит всю нужную информацию, извлекаем её
        let to = transitionContext.view(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!) // Тот самый фрейм, который мы задали в PresentationController
        // Смещаем контроллер за границу экрана
        let offset = offsetBy(with: finalFrame)
        to.frame = finalFrame.offsetBy(dx: offset.dx, dy: offset.dy)
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            to.frame = finalFrame // Возвращаем на место, так он выезжает снизу
        }
        
        animator.addCompletion { (position) in
            // Завершаем переход, если он не был отменён
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator
    }
    
}
