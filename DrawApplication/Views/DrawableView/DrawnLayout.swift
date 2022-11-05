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
    
    private (set) var layouts: [Layout] = [Layout()]
    private (set) var currentLayoutIndex: Int = 0
    var currentWidth = 6
    var currentColor: UIColor = .black
    var currentLineType: LineType = .solid
    var currentState: DrawableViewState = .draw
    
    var currentLayout: Layout? {
        guard layouts.count > 0 else { return nil }
        return layouts[currentLayoutIndex]
    }
    
    init(with delegate: DrawnLayoutDelegate) {
        self.delegate = delegate
        checkState()
    }
    
    func setupInitialLayoutIfNeeded(with layout: Layout?) {
        layouts = [layout ?? Layout()]
        checkState()
    }
    
    func setupNewLayout() {
        guard layouts.count > 0 else {
            layouts.append(Layout())
            appendLine()
            checkState()
            return
        }
        /// удаляем из массива все изменения, которые больше индексом
        /// и дублируем текущий лаяут в массив для его преобразования
        if currentLayoutIndex > layouts.count - 1 {
            currentLayoutIndex = layouts.count - 1
        }
        layouts = Array(layouts[0...currentLayoutIndex])
        layouts.append(currentLayout!)
        appendLine()
        checkState()
    }
    
    private func appendLine() {
        guard layouts.count > 0 else { return }
        currentLayoutIndex = layouts.count - 1
        let color = currentState == .draw ? currentColor : .white
        layouts[currentLayoutIndex].appendLine(Line(points: [], lineWidth: currentWidth, lineColor: color, lineType: currentLineType))
    }
    
    private func checkState() {
        if layouts.count < 2 {
            delegate?.indexInEdge(with: .empty)
            return
        }
        if currentLayoutIndex == layouts.count - 1 {
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
        guard layouts.count > 0 else { return }
        layouts[currentLayoutIndex].appendPoint(point)
    }
    
    func clearLayout() {
        currentLayoutIndex = 0
        layouts = [Layout()]
        checkState()
    }
    
    func removeLastLayout() {
        currentLayoutIndex -= 1
        layouts.removeLast()
        checkState()
    }
    
    func decreaseIndex() {
        if currentLayoutIndex > 0 {
            currentLayoutIndex -= 1
        }
        checkState()
    }
    
    func increaseIndex() {
        if currentLayoutIndex < layouts.count - 1 {
            currentLayoutIndex += 1
        }
        checkState()
    }
    
}
