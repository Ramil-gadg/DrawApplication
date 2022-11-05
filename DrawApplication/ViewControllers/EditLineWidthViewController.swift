//
//  EditLineWidthViewController.swift
//  DrawApp
//
//  Created by Рамил Гаджиев on 24.09.2022.
//

import UIKit

class EditLineWidthViewController: BaseViewController {
    var changedLineWidth: ((Int) -> Void)?
    
    private var sliderValue: Int
    
    private var valueLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        return lbl
    }()
    
    private var setSliaderValueBtn: ActionButton = {
        let btn = ActionButton()
        btn.setTitle("Установить", for: .normal)
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
    
    init(sliderValue: Int) {
        self.sliderValue = sliderValue
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
        print("deinit EditLineWidthViewController")
    }
    
    private func initUI() {
        view.backgroundColor = .white
        view.addSubview(slider)
        view.addSubview(setSliaderValueBtn)
        view.addSubview(valueLbl)
        slider.value = Float(sliderValue)
        valueLbl.text = "\(sliderValue)"
    }
    
    private func initConstraints() {
        valueLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(valueLbl.snp.bottom).offset(42)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        setSliaderValueBtn.snp.makeConstraints { make in
            make.top.equalTo(slider.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(180)
        }
    }
    
    private func initListeners() {
        slider.addTarget(self, action: #selector(sliderMoved(_:)), for: .valueChanged)
        setSliaderValueBtn.addTarget(self, action: #selector(setSliderValue), for: .touchUpInside)
    }
    
    @objc func sliderMoved(_ slider: UISlider) {
        let intValue = Int(slider.value)
        self.sliderValue = intValue
        valueLbl.text = "\(intValue)"
    }
    
    @objc func setSliderValue() {
        changedLineWidth?(sliderValue)
        self.dismiss(animated: true)
    }
}
