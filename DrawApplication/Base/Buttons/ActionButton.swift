//
//  ActionButton.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 18.09.2022.
//

import UIKit

class ActionButton: UIButton {
    var touchDown: ((_ button: UIButton) -> Void)?
    var touchExit: ((_ button: UIButton) -> Void)?
    var touchUp: ((_ button: UIButton) -> Void)?
    var touchDownLong: ((_ button: UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponent()
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initComponent()
        initConstraints()
    }
    
    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            guard newValue != isHighlighted else { return }
            
            if newValue == true {
                titleLabel?.alpha = 0.25
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.titleLabel?.alpha = 1
                }
                super.isHighlighted = newValue
            }
            
            super.isHighlighted = newValue
        }
    }
    
    func initComponent() {
        // this is my most common setup, but you can customize to your liking
        addTarget(self, action: #selector(touchDown(_:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchExit(_:)), for: [.touchCancel, .touchDragExit])
        addTarget(self, action: #selector(touchUp(_:)), for: [.touchUpInside])
    }
    
    func initConstraints() {
        
    }
    
    func addLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 1.5
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            touchDownLong?(self)
        }
    }
    
    // actions
    @objc func touchDown(_ sender: UIButton) {
        touchDown?(sender)
    }
    
    @objc func touchExit(_ sender: UIButton) {
        touchExit?(sender)
    }
    
    @objc func touchUp(_ sender: UIButton) {
        touchUp?(sender)
    }
}
