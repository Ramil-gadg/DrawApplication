//
//  NextPrevNavTitleView.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 18.09.2022.
//

import UIKit
import SnapKit

protocol NextPrevNavTitleViewDelegate: AnyObject {
    func nextStep()
    func previousStep()
}

class NextPrevNavTitleView: UIView {
    
    weak var delegate: NextPrevNavTitleViewDelegate?
    
    private let nextButton: ActionButton = {
        let button = ActionButton()
        button.setImage(UIImage(systemName: "arrow.uturn.right"), for: .normal)
        return button
    }()
    
    private let previousButton: ActionButton = {
        let button = ActionButton()
        button.setImage(UIImage(systemName: "arrow.uturn.left"), for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        initUI()
        initConstrants()
        initListeners()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonsEnable(with edge: Edge) {
        switch edge {
        case .min:
            previousButton.isEnabled = false
            nextButton.isEnabled = true
        case .middle:
            previousButton.isEnabled = true
            nextButton.isEnabled = true
        case .max:
            previousButton.isEnabled = true
            nextButton.isEnabled = false
        case .empty:
            previousButton.isEnabled = false
            nextButton.isEnabled = false
        }
    }
    
    private func initUI() {
        self.addSubview(nextButton)
        self.addSubview(previousButton)
    }
    
    private func initConstrants() {
        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.leading.equalTo(previousButton.snp.trailing).offset(20)
            make.top.equalToSuperview().offset(8)
        }
    }
    
    private func initListeners() {
        nextButton.touchUp = { [weak self] _ in
            self?.delegate?.nextStep()
        }
        
        previousButton.touchUp = { [weak self] _ in
            self?.delegate?.previousStep()
        }
    }
    
}
