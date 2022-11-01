//
//  EditBrushViewController.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 01.11.2022.
//

import UIKit

class EditBrushViewController: BaseViewController {
        
    private weak var delegate: EditBrushViewControllerDelegate?
    private var currentColor: UIColor
    private var currentWidth: Int
    private var currentType: LineType
    private var currentState: DrawableViewState
    
    private lazy var allButtons: [EditBrushAction] = [.lineWidth, .lineType, .isEraser(currentState == .erase ? true : false)]
    
    private let colorSelector: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = true
        return colorWell
    }()
    
    private let scrollView: UIScrollView = {
       let scroll = UIScrollView()
        return scroll
    }()
    
    private let stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
    init(
        width: Int,
        color: UIColor,
        currentType: LineType,
        currentState: DrawableViewState,
        delegate: EditBrushViewControllerDelegate) {
            
        self.delegate = delegate
        self.currentColor = color
        self.currentWidth = width
        self.currentType = currentType
        self.currentState = currentState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initUI()
        initConstraints()
        initListeners()
    }
    
    private func initUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(colorSelector)
        setupActionButtons()
        colorSelector.selectedColor = currentColor
    }
    
    private func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        colorSelector.snp.makeConstraints { make in
            make.height.width.equalTo(32)
        }
        
        stackView.subviews.forEach {
            ($0 as? ActionButton)?.snp.makeConstraints { make in
                make.width.equalTo(48)
                make.height.equalTo(32)
            }
        }
    }
    
    private func initListeners() {
        colorSelector.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
    }

    private func setupActionButtons() {
        allButtons.forEach { buttonType in
            let btn = ActionButton()
            btn.setImage(UIImage(systemName: buttonType.imageName) ?? UIImage(named: buttonType.imageName), for: .normal)
            btn.tintColor = .cyan
            stackView.addArrangedSubview(btn)
            btn.touchUp = { [weak self] _ in
                guard let self = self else { return }
                
                switch buttonType {
                case .lineWidth:
                    let editLineWidthVC = EditLineWidthViewController(sliderValue: self.currentWidth)
                    editLineWidthVC.modalPresentationStyle = .custom
                    editLineWidthVC.transitioningDelegate = self.setTransitionProvider(with: .fromBottom)
                    self.transitionProvider?.dimmColor = .black.withAlphaComponent(0.4)
                    self.transitionProvider?.width = UIScreen.main.bounds.width
                    self.transitionProvider?.height = 300
                    editLineWidthVC.changedLineWidth = { [weak self] sliderValue in
                        self?.dismiss(animated: true)
                        self?.currentWidth = sliderValue
                        self?.delegate?.lineWidthChanged(with: sliderValue)
                    }
                    self.present(editLineWidthVC, animated: true)
                case .lineType:
                    let editLineTypeVC = EditLineTypeViewController(type: self.currentType, lineColor: self.currentColor)
                    editLineTypeVC.modalPresentationStyle = .custom
                    editLineTypeVC.transitioningDelegate = self.setTransitionProvider(with: .fromLeft)
                    self.transitionProvider?.dimmColor = .black.withAlphaComponent(0.7)
                    self.transitionProvider?.width = 290
                    self.transitionProvider?.height = 114
                    editLineTypeVC.changedLineType = { [weak self] lineType in
                        self?.dismiss(animated: true)
                        self?.currentType = lineType
                        if self?.currentState == .draw {
                            self?.delegate?.lineTypeChanged(with: lineType)
                        }
                    }
                    self.present(editLineTypeVC, animated: true)
                case .isEraser:
                    self.currentState = self.currentState == .draw ? .erase : .draw
                    let image = EditBrushAction.isEraser(self.currentState == .draw ? false : true).imageName
                    btn.setImage(UIImage(named: image), for: .normal)
                    if self.currentState == .erase {
                        self.delegate?.lineTypeChanged(with: .solid)
                    } else {
                        self.delegate?.lineTypeChanged(with: self.currentType)
                    }
                    self.delegate?.drawStateChanged(with: self.currentState)
                }
            }
        }
    }
    
    @objc private func colorChanged() {
        currentColor = colorSelector.selectedColor ?? .red
        delegate?.colorChanged(with: currentColor)
    }
    
    deinit {
        print("deinit EditBrushViewController")
    }
}
