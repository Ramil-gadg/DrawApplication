//
//  Line.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 19.09.2022.
//

import UIKit

struct Line {
    var points: [CGPoint]
    var lineWidth = 10
    var lineColor: UIColor = .red
    var lineType: LineType = .solid
}
