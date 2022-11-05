//
//  EditBrushAction.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 24.09.2022.
//

import Foundation

enum EditBrushAction {
    case lineWidth
    case lineType
    case isEraser(Bool)
    
    var imageName: String {
        switch self {
        case .lineWidth:
            return "scribble.variable"
        case .lineType:
            return "wand.and.rays"
        case .isEraser(let isEraser):
            return isEraser ? "eraser_icon" : "pen_icon"
        }
    }
}
