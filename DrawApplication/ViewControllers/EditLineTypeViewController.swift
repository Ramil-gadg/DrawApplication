//
//  EditLineTypeViewController.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 02.10.2022.
//

import UIKit
import SnapKit

class EditLineTypeViewController: UIViewController {
    
    private var currentType: LineType
    private var lineColor: UIColor
    var changedLineType: ((LineType) -> Void)?
    private var dissmisTapGesture: UITapGestureRecognizer?
        
    private let scrollView: UIScrollView = {
       let scroll = UIScrollView()
        scroll.backgroundColor = .white
        scroll.layer.cornerRadius = 20
        return scroll
    }()
    
    private let stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    private let solidBtn: ActionButton = {
        let btn = ActionButton()
        btn.setImage(UIImage(systemName: "minus"), for: .normal)
        btn.tintColor = .darkGray
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    private let dottedBtn: ActionButton = {
        let btn = ActionButton()
        btn.setImage(UIImage(named: "line_dashed"), for: .normal)
        btn.tintColor = .darkGray
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    private var dismissedView: UIView?
    
    private var editDashedLineView = SliderDashedLineView()
        
    init(type: LineType, lineColor: UIColor) {
        self.currentType = type
        self.lineColor = lineColor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initConstraints()
        initListeners()
    }
    
    deinit {
        print("deinit EditLineTypeViewController")
    }
    
    private func initUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        view.addSubview(editDashedLineView)
        editDashedLineView.alpha = 0
        stackView.addArrangedSubview(solidBtn)
        stackView.addArrangedSubview(dottedBtn)
        updateButtonsColor()
        updateDismissedView()
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    private func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(80)
            make.left.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        editDashedLineView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(scrollView.snp.right).offset(10)
        }
        
        stackView.subviews.forEach {
            ($0 as? ActionButton)?.snp.makeConstraints { make in
                make.width.equalTo(32)
                make.height.equalTo(32)
            }
        }
    }
    
    private func initListeners() {
        editDashedLineView.changedLineDashedDistance = { [weak self] distance in
            guard let self = self else { return }
            self.currentType = .dotted(space: distance)
            self.changedLineType?(self.currentType)
        }
        
        solidBtn.touchUp = { [weak self] _ in
            guard let self = self else { return }
            self.updateButtonsColor()
            self.currentType = .solid
            self.changedLineType?(self.currentType)
        }
        
        dottedBtn.touchUp = { [weak self] _ in
            guard let self = self else { return }
            self.updateButtonsColor()
            self.updateDismissedView()
            var distance = 10
            if case .dotted(let value) = self.currentType {
                distance = value
            }
            UIView.animate(withDuration: 0.4) {
                if self.editDashedLineView.alpha == 0 {
                    self.editDashedLineView.showView(with: distance, color: self.lineColor)
                } else {
                    self.editDashedLineView.hideView()
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func updateButtonsColor() {
        switch currentType {
        case .solid:
            solidBtn.backgroundColor = .cyan
            dottedBtn.backgroundColor = .white
        case .dotted(_):
            solidBtn.backgroundColor = .white
            dottedBtn.backgroundColor = .cyan
        }
    }
    
    private func updateDismissedView() {
        if dismissedView == nil {
            dismissedView = UIView()
            view.addSubview(dismissedView!)
            dismissedView?.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                make.left.equalTo(scrollView.snp.right).offset(10)
                make.width.equalTo(200)
            }
            dissmisTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
            dismissedView?.addGestureRecognizer(dissmisTapGesture!)
        } else {
            dismissedView?.removeFromSuperview()
            dismissedView = nil
        }
    }
    
}
