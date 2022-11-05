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
    
    private lazy var layout = DrawnLayout(with: self)
    private var state: DrawableViewState = .draw
    private var eraseWidth: CGFloat = 10
    weak var delegate: DrawableViewDelegate?
    private var initialLayout: Layout?
    
    private var longGesture = UILongPressGestureRecognizer()
    
    
    var currentWidth: Int {
        layout.currentWidth
    }
    
    var currentColor: UIColor {
        layout.currentColor
    }
    
    var currentLineType: LineType {
        layout.currentLineType
    }
    
    var currentState: DrawableViewState {
        layout.currentState
    }
    
    var currentLayout: Layout? {
        layout.currentLayout
    }
    
    init(with initialLayout: Layout?) {
        self.initialLayout = initialLayout
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
        
        guard let currentLines = layout.currentLayout?.lines else { return }
        
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
        layout.setupNewLayout()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let point = touches.first?.location(in: self),
              (layout.currentLayout?.lines.count) ?? 0 > 0 else {
                  return
              }
        layout.appendPointInCurrentLine(point)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if layout.currentLayout?.lines.last?.points.isEmpty == true {
            layout.removeLastLayout()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if layout.currentLayout?.lines.last?.points.isEmpty == true {
            layout.removeLastLayout()
        }
    }
    
    func setupInitialLayoutIfNeeded() {
        self.layout.setupInitialLayoutIfNeeded(with: initialLayout)
        setNeedsDisplay()
    }
    
    func clear() {
        layout.clearLayout()
        setNeedsDisplay()
    }
    
    func pop() {
        layout.decreaseIndex()
        setNeedsDisplay()
    }
    
    func push() {
        layout.increaseIndex()
        setNeedsDisplay()
    }
    
    func changeLineWidth(with width: Int) {
        layout.currentWidth = width
    }
    
    func changeLineColor(with color: UIColor) {
        layout.currentColor = color
    }
    
    func changeLineType(with type: LineType) {
        layout.currentLineType = type
    }
    
    func changeState(with state: DrawableViewState) {
        layout.currentState = state
    }

}

// MARK: - DrawnLayoutDelegate
extension DrawableView: DrawnLayoutDelegate {
    
    func indexInEdge(with edge: Edge) {
        delegate?.layoutsEdge(with: edge)
    }
    
}
