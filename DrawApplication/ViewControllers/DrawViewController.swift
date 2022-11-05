//
//  DrawViewController.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 16.09.2022.
//

import UIKit

protocol DrawViewControllerDelegate: AnyObject {
    func savePicture(index: Int?, image: UIImage?, layout: Layout?)
}

class DrawViewController: BaseViewController {
    
    weak var delegate: DrawViewControllerDelegate?
    private let index: Int?

    private var navTitleView = NextPrevNavTitleView()

    private var drawableView: DrawableView
    
    init(index: Int?, layout: Layout?) {
        self.index = index
        drawableView = DrawableView(with: layout)
        super.init(nibName: nil, bundle: nil)
        drawableView.delegate = self
        drawableView.setupInitialLayoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(index: nil, layout: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initConstraints()
    }
    
    private func initUI() {
        view.backgroundColor = .white
        drawableView.backgroundColor = .white
        view.addSubview(drawableView)
        setupRightNavigationBar()
        navigationItem.titleView = navTitleView
        navTitleView.delegate = self
    }
    
    private func setupRightNavigationBar() {
        let clearBarBtn = setupBarButtonItem(with: "xmark.circle", actionStr: "clearPrint")
        let editBarBtn = setupBarButtonItem(with: "paintbrush.pointed", actionStr: "editPrint")
        let saveBarBtn = setupBarButtonItem(with: "checkmark.circle", actionStr: "savePrint")
        
        navigationItem.rightBarButtonItems = [saveBarBtn, editBarBtn, clearBarBtn]
    }
    
    private func setupBarButtonItem(with imageName: String, actionStr: String) -> UIBarButtonItem {
        let button = ActionButton()
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.addTarget(self, action: Selector(actionStr), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return UIBarButtonItem(customView: button)
    }
    
    private func initConstraints() {
        
        drawableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    @objc func editPrint() {
        let editVC = EditBrushViewController(
            width: drawableView.currentWidth,
            color: drawableView.currentColor,
            currentType: drawableView.currentLineType,
            currentState: drawableView.currentState,
            delegate: self
        )
        editVC.modalPresentationStyle = .custom
        editVC.transitioningDelegate = setTransitionProvider(with: .fromLeft)
        transitionProvider?.dimmColor = .black.withAlphaComponent(0.4)
        transitionProvider?.width = 80
        transitionProvider?.height = 198
        self.present(editVC, animated: true)
    }
    
    @objc func clearPrint() {
        drawableView.clear()
    }
    @objc func savePrint() {
        let renderer = UIGraphicsImageRenderer(size: drawableView.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: drawableView.bounds, afterScreenUpdates: true)
        }
        if drawableView.currentLayout?.lines.isEmpty == false {
            delegate?.savePicture(index: index, image: image, layout: drawableView.currentLayout)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - NextPrevNavTitleViewDelegate
extension DrawViewController: NextPrevNavTitleViewDelegate {
    func nextStep() {
        drawableView.push()
    }
    func previousStep() {
        drawableView.pop()
    }
}

// MARK: - DrawableViewDelegate
extension DrawViewController: DrawableViewDelegate {
    func layoutsEdge(with edge: Edge) {
        navTitleView.setButtonsEnable(with: edge)
    }
}

// MARK: - EditBrushViewControllerDelegate
extension DrawViewController: EditBrushViewControllerDelegate {
    func lineWidthChanged(with width: Int) {
        drawableView.changeLineWidth(with: width)
    }
    func drawStateChanged(with state: DrawableViewState) {
        drawableView.changeState(with: state)
    }
    func colorChanged(with color: UIColor) {
        drawableView.changeLineColor(with: color)
    }
    func lineTypeChanged(with type: LineType) {
        drawableView.changeLineType(with: type)
    }
}
