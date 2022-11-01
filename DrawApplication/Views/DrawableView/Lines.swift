//
//  Lines.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 19.09.2022.
//

import UIKit

struct Lines {
    
    var lines: [Line] = []
    var eraseLines: [Line] = []
    
    subscript(index: Int) -> Line {
        return lines[index]
    }
    
    mutating func appendLine(_ line: Line) {
        lines.append(line)
    }
    
    mutating func appendPoint(_ point: CGPoint) {
        guard lines.count > 0 else { return }
        lines[lines.count - 1].points.append(point)
    }
    
    mutating func changePoints(with points: [CGPoint], lineIndex: Int) {
        guard lines.count > 0 else { return }
        lines[lineIndex].points = points
    }
    
    mutating func appendEraseLine(_ line: Line) {
        eraseLines.append(line)
    }
    
}
