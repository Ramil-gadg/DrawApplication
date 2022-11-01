//
//  BaseViewController.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 01.11.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    var transitionProvider: TransitionProvider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (transitioningDelegate as? TransitionProvider)?.delegate = self
    }
    
    func setTransitionProvider(with direction: PopoverDirection) -> TransitionProvider {
        transitionProvider = TransitionProvider(transitionDirection: direction)
        transitionProvider?.delegate = self
        return transitionProvider!
    }
}

extension BaseViewController: TransitionProviderDelegate {
    func dismiss(with animated: Bool) {
        self.dismiss(animated: animated)
    }
}
