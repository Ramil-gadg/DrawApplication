//
//  TransitionProvider.swift
//  CustomPresentation
//
//  Created by Рамил Гаджиев on 11.09.2022.
//

import UIKit

class TransitionProvider: NSObject, UIViewControllerTransitioningDelegate {
    
    var duration: TimeInterval = 0.3
    var dimmColor: UIColor?
    var transitionDirection: PopoverDirection
    var height: CGFloat?
    var width: CGFloat?
    var dismissWithAnimation: Bool  = true
    weak var delegate: TransitionProviderDelegate?
    
    private let driver = TransitionDriver()
    
    init(transitionDirection: PopoverDirection) {
        self.transitionDirection = transitionDirection
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentAnimation(duration: duration, transitionDirection: transitionDirection)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimation(duration: duration, transitionDirection: transitionDirection)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        driver.link(to: presented)

        let controller = DimmTransitionPresentationController(presentedViewController: presented, presenting: presenting ?? source, transitionDirection: transitionDirection, dimmColor: dimmColor)
        controller.driver = driver
        controller.customHeight = height
        controller.customWidth = width
        controller.dismissWithAnimation = dismissWithAnimation
        controller.dismissDelegate = self
                
        return controller
    }
}

extension TransitionProvider: Dismissed {
    func dismiss(animated: Bool) {
        self.delegate?.dismiss(with: animated)
    }
}
