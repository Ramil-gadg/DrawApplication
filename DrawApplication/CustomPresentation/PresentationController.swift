//
//  PresentationController.swift
//  CustomPresentation
//
//  Created by Рамил Гаджиев on 11.09.2022.
//

import UIKit

class TransitionPresentationController: UIPresentationController {
    
    var transitionDirection: PopoverDirection
    var customHeight: CGFloat?
    var customWidth: CGFloat?
    
    var driver: TransitionDriver!
    
    var height: CGFloat {
        customHeight ?? containerView!.bounds.height/2
    }
    var width: CGFloat {
        customWidth ?? containerView!.bounds.width/2
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard containerView != nil else { return .zero }
        return CGRect(
            origin: origin(),
            size: CGSize(width: width, height: height)
        )
    }
    
    init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        transitionDirection: PopoverDirection
    ) {
        self.transitionDirection = transitionDirection
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if completed {
            driver.direction = .dismiss
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 20
    }
    
    private func origin() -> CGPoint {
        switch transitionDirection {
            
        case .fromBottom:
            return CGPoint(x: (containerView!.bounds.width - width)/2, y: containerView!.bounds.height - height)
        case .fromTop:
            return CGPoint(x: (containerView!.bounds.width - width)/2, y: 0)
        case .fromLeft:
            return CGPoint(x: 0, y: (containerView!.bounds.height - height)/2)
        case .fromRight:
            return CGPoint(x: containerView!.bounds.width - width, y: (containerView!.bounds.height - height)/2)
        }
    }
}
