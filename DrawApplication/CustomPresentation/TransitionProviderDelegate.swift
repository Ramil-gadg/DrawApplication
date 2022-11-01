//
//  TransitionProviderDelegate.swift
//  CustomPresentation
//
//  Created by Рамил Гаджиев on 11.09.2022.
//

import Foundation

protocol TransitionProviderDelegate: AnyObject {
    func dismiss(with animated: Bool)
}
