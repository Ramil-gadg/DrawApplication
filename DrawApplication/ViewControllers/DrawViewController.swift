//
//  DrawViewController.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 16.09.2022.
//

import UIKit

enum DrawVCState {
    case show
    case edit
}

protocol DrawViewControllerDelegate: AnyObject {
    func savePicture(index: Int?, image: UIImage?, layout: Layout?)
}

class DrawViewController: BaseViewController {
    weak var delegate: DrawViewControllerDelegate?
    private let index: Int?
    private var layout: Layout?

    private var navTitleView = NextPrevNavTitleView()
    
    private lazy var clearLayoutBarBtn = setupBarButtonItem(with: "xmark.circle", actionStr: "clearLayout")
    private lazy var editLineBarBtn = setupBarButtonItem(with: "paintbrush.pointed", actionStr: "editLine")
    private lazy var saveLayoutBtn = setupBarButtonItem(with: "checkmark.circle", actionStr: "saveLayout")
    private lazy var sharePictureBarBtn = setupBarButtonItem(with: "square.and.arrow.up", actionStr: "sharePicture")
    private lazy var editPictureBarBtn = setupBarButtonItem(with: "slider.horizontal.3", actionStr: "editPicture")

    private var drawableView: DrawableView
    private var state: DrawVCState = .show
    
    init(index: Int?, layout: Layout?) {
        self.index = index
        self.layout = layout
        drawableView = DrawableView()
        super.init(nibName: nil, bundle: nil)
        drawableView.delegate = self
        drawableView.setupInitialLayout(with: layout)
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
        state = (layout == nil) ? .edit : .show
        switch state {
        case .show:
            setupShowPictureState(with: layout)
        case .edit:
            setupEditPictureState()
        }
    }
    
    private func initUI() {
        view.backgroundColor = .white
        drawableView.backgroundColor = .white
        view.addSubview(drawableView)
        navigationItem.titleView = navTitleView
        navTitleView.delegate = self
    }
    
    private func setupShowPictureState(with layout: Layout?) {
        drawableView.isUserInteractionEnabled = false
        self.layout = layout
        drawableView.setupInitialLayout(with: layout)
        navigationItem.titleView?.isHidden = true
        setupShowPictureRightNavigationBar()
    }
    
    private func setupEditPictureState() {
        drawableView.isUserInteractionEnabled = true
        navigationItem.titleView?.isHidden = false
        setupEditPictureRightNavigationBar()
    }
    
    private func setupEditPictureRightNavigationBar() {
        navigationItem.rightBarButtonItems = [saveLayoutBtn, editLineBarBtn, clearLayoutBarBtn]
    }
    
    private func setupShowPictureRightNavigationBar() {
        navigationItem.rightBarButtonItems = [sharePictureBarBtn, editPictureBarBtn]
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
    
    @objc func editLine() {
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
    @objc func clearLayout() {
        drawableView.clear()
    }
    @objc func saveLayout() {
        if drawableView.currentLayoutIsEmpty {
            print("Empty")
            return
        }
        let alert = UIAlertController(title: "Сохранить изображение в альбом?", message: "", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            let layout = self?.drawableView.currentLayout
            self?.setupShowPictureState(with: layout)
            self?.savePictureInAlbom(layout: layout)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func savePictureInAlbom(layout: Layout?) {
        let renderer = UIGraphicsImageRenderer(size: drawableView.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: drawableView.bounds, afterScreenUpdates: true)
        }
        delegate?.savePicture(index: index, image: image, layout: layout)
    }
    
    @objc func sharePicture() {
        let renderer = UIGraphicsImageRenderer(size: drawableView.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: drawableView.bounds, afterScreenUpdates: true)
        }
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    @objc func editPicture() {
        setupEditPictureState()
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
