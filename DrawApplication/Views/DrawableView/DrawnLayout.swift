//
//  DrawnLayout.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 19.09.2022.
//

import UIKit

protocol DrawnLayoutDelegate: AnyObject {
    func indexInEdge(with edge: Edge)
}

class DrawnLayout {
    
    weak var delegate: DrawnLayoutDelegate?
    
    var layout: [Lines] = [Lines()]
    var currentLayoutIndex: Int = 0
    var currentWidth = 10
    var currentColor: UIColor = .red
    var currentLineType: LineType = .solid
    var currentState: DrawableViewState = .draw
    
    var currentLayout: Lines? {
        guard layout.count > 0 else { return nil }
        return layout[currentLayoutIndex]
    }
    
    init(with delegate: DrawnLayoutDelegate) {
        self.delegate = delegate
        checkState()
    }
    
    subscript(index: Int) -> Lines {
        return layout[index]
    }
    
    func setupNewLayout() {
        guard layout.count > 0 else {
            layout.append(Lines())
            appendLine()
            checkState()
            return
        }
        /// удаляем из массива все изменения, которые больше индексом
        /// и дублируем текущий лаяут в массив для его преобразования
        if currentLayoutIndex > layout.count - 1 {
            currentLayoutIndex = layout.count - 1
        }
        layout = Array(layout[0...currentLayoutIndex])
        layout.append(currentLayout!)
        appendLine()
        checkState()
    }
    
    private func appendLine() {
        guard layout.count > 0 else { return }
        currentLayoutIndex = layout.count - 1
        let color = currentState == .draw ? currentColor : .white
        layout[currentLayoutIndex].appendLine(Line(points: [], lineWidth: currentWidth, lineColor: color, lineType: currentLineType))
    }
    
    private func checkState() {
        if layout.count < 2 {
            delegate?.indexInEdge(with: .empty)
            return
        }
        if currentLayoutIndex == layout.count - 1 {
            delegate?.indexInEdge(with: .max)
            return
        }
        if currentLayoutIndex == 0 {
            delegate?.indexInEdge(with: .min)
            return
        }
        delegate?.indexInEdge(with: .middle)
    }
    
    func appendPointInCurrentLine(_ point: CGPoint) {
        guard layout.count > 0 else { return }
        layout[currentLayoutIndex].appendPoint(point)
    }
    
    func clearLayout() {
        currentLayoutIndex = 0
        layout = [Lines()]
        checkState()
    }
    
    func removeLastLayout() {
        currentLayoutIndex -= 1
        layout.removeLast()
        checkState()
    }
    
    func decreaseIndex() {
        if currentLayoutIndex > 0 {
            currentLayoutIndex -= 1
        }
        checkState()
    }
    
    func increaseIndex() {
        if currentLayoutIndex < layout.count - 1 {
            currentLayoutIndex += 1
        }
        checkState()
    }
    
}
