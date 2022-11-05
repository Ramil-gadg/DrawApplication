//
//  SliderDashedLineView.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 02.10.2022.
//

import UIKit
import SnapKit

class SliderDashedLineView: UIView {
    var changedLineDashedDistance: ((Int) -> Void)?
    
    private var sliderValue: Int = 1
    private var lineColor: UIColor = .black
    var constraint: Constraint?
    
    private var setSliderValueBtn: ActionButton = {
        let btn = ActionButton()
        btn.setTitle("Ok", for: .normal)
        btn.backgroundColor = .blue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 30
        slider.minimumValue = 1
        return slider
    }()
    
    private var line: CAShapeLayer?
    
    init() {
        super.init(frame: .zero)
        initUI()
        initConstraints()
        initListeners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showView(with value: Int, color: UIColor) {
        alpha = 1
        sliderValue = value
        lineColor = color
        slider.value = Float(sliderValue)
        constraint?.update(offset: 200)
        stretchLine()
    }
    
    func hideView() {
        self.alpha = 0
        constraint?.update(offset: 80)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0.2
        animation.duration = 0.3
        line?.add(animation, forKey: "hideLineAnimation")
    }
    
    private func stretchLine() {
        line?.removeFromSuperlayer()
        line = nil
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineDashPattern = [10, NSNumber(value: sliderValue)]
        shapeLayer.lineWidth = 2.0
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: 20))
        path.addLine(to: CGPoint(x: 180, y: 20))
        shapeLayer.path = path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.1
        animation.duration = 0.4
        shapeLayer.add(animation, forKey: "stretchLineAnimation")
        
        line = shapeLayer
        layer.addSublayer(line!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
    deinit {
        line?.removeAnimation(forKey: "stretchLineAnimation")
    }
     
    private func initUI() {
        backgroundColor = .white
        addSubview(slider)
        addSubview(setSliderValueBtn)
    }
    
    private func initConstraints() {
        
        self.snp.makeConstraints { make in
            constraint = make.width.equalTo(80).constraint
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        setSliderValueBtn.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
    }
    
    private func initListeners() {
        slider.addTarget(self, action: #selector(sliderMoved(_:)), for: .valueChanged)
        setSliderValueBtn.addTarget(self, action: #selector(setSliderValue), for: .touchUpInside)
    }
    
    @objc private func sliderMoved(_ slider: UISlider) {
        let intValue = Int(slider.value)
        self.sliderValue = intValue
        line?.lineDashPattern = [10, NSNumber(value: intValue)]
    }
    
    @objc private func setSliderValue() {
        changedLineDashedDistance?(sliderValue)
    }
}
