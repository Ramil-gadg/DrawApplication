//
//  DrawableView.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 16.09.2022.
//

import UIKit

enum DrawableViewState {
    case draw
    case erase
}

enum Edge {
    case min
    case middle
    case max
    case empty
}

protocol DrawableViewDelegate: AnyObject {
    func layoutsEdge(with edge: Edge)
}

class DrawableView: UIView {
    private lazy var layouts = DrawnLayout(with: self)
    weak var delegate: DrawableViewDelegate?
        
    var currentWidth: Int {
        layouts.currentWidth
    }
    
    var currentColor: UIColor {
        layouts.currentColor
    }
    
    var currentLineType: LineType {
        layouts.currentLineType
    }
    
    var currentState: DrawableViewState {
        layouts.currentState
    }
    
    var currentLayout: Layout? {
        layouts.currentLayout
    }
    
    var currentLayoutIsEmpty: Bool {
        guard let currentLayout = currentLayout else {
            return true
        }
        return currentLayout.lines.isEmpty
    }
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let currentLines = layouts.currentLayout?.lines else { return }
        
        for pointsLine in currentLines {
            
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            context.setStrokeColor(pointsLine.lineColor.cgColor)
            context.setLineWidth(CGFloat(pointsLine.lineWidth))
            
            if case .dotted(let value) = pointsLine.lineType {
                context.setLineDash(phase: 0, lengths: [10, CGFloat(value)])
            } else {
                context.setLineDash(phase: 0, lengths: [10, 0])
            }
            for (indexNumber, linePoint) in pointsLine.points.enumerated() {
                if indexNumber == 0 {
                    context.move(to: linePoint)
                } else {
                    context.addLine(to: linePoint)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        layouts.setupNewLayout()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let point = touches.first?.location(in: self),
              (layouts.currentLayout?.lines.count) ?? 0 > 0 else {
                  return
              }
        layouts.appendPointInCurrentLine(point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if layouts.currentLayout?.lines.last?.points.isEmpty == true {
            layouts.removeLastLayout()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if layouts.currentLayout?.lines.last?.points.isEmpty == true {
            layouts.removeLastLayout()
        }
    }
    
    func setupInitialLayout(with layout: Layout?) {
        self.layouts.setupInitialLayout(with: layout ?? Layout())
        setNeedsDisplay()
    }
    
    func clear() {
        layouts.clearLayout()
        setNeedsDisplay()
    }
    
    func pop() {
        layouts.decreaseIndex()
        setNeedsDisplay()
    }
    
    func push() {
        layouts.increaseIndex()
        setNeedsDisplay()
    }
    
    func changeLineWidth(with width: Int) {
        layouts.currentWidth = width
    }
    
    func changeLineColor(with color: UIColor) {
        layouts.currentColor = color
    }
    
    func changeLineType(with type: LineType) {
        layouts.currentLineType = type
    }
    
    func changeState(with state: DrawableViewState) {
        layouts.currentState = state
    }
}

// MARK: - DrawnLayoutDelegate
extension DrawableView: DrawnLayoutDelegate {
    
    func indexInEdge(with edge: Edge) {
        delegate?.layoutsEdge(with: edge)
    }
}
