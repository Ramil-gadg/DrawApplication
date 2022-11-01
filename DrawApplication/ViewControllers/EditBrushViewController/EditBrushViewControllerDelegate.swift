//
//  EditBrushViewControllerDelegate.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 24.09.2022.
//

import UIKit

protocol EditBrushViewControllerDelegate: AnyObject {
    func lineWidthChanged(with width: Int)
    func colorChanged(with color: UIColor)
    func drawStateChanged(with state: DrawableViewState)
    func lineTypeChanged(with type: LineType)
}
