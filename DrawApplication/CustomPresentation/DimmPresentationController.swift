//
//  DimmPresentationController.swift
//  CustomPresentation
//
//  Created by Рамил Гаджиев on 11.09.2022.
//

import UIKit

class DimmTransitionPresentationController: TransitionPresentationController {
    
    weak var dismissDelegate: Dismissed?
    var dismissWithAnimation: Bool  = true
    
    var dimmColor: UIColor?
    
    lazy var dimmedView: UIView = {
       let view = UIView()
        view.backgroundColor = dimmColor
        view.alpha = 0
        return view
    }()
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, transitionDirection: PopoverDirection, dimmColor: UIColor?) {
        self.dimmColor = dimmColor
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController, transitionDirection: transitionDirection)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(dimmedView, at: 0)
        dimmedView.addGestureRecognizer(tapGesture)
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmedView.alpha = 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            dimmedView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmedView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            dimmedView.removeFromSuperview()
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmedView.frame = containerView!.frame
    }
    
    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }

        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }
    
    @objc private func dismiss() {
        dismissDelegate?.dismiss(animated: dismissWithAnimation)
    }
}
