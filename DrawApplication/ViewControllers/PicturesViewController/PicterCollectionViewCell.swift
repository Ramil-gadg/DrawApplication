//
//  PicterCollectionViewCell.swift
//  DrawApplication
//
//  Created by Рамил Гаджиев on 02.11.2022.
//

import UIKit

protocol PicterCollectionViewCellDelegate: AnyObject {
    func openImage(with index: Int?)
    func deleteImage(with index: Int?)
}

class PicterCollectionViewCell: UICollectionViewCell {
    static let identifier = "PicterCollectionViewCell"
    
    weak var delegate: PicterCollectionViewCellDelegate?
    private var index: Int?
    
    private let pictureImageView = UIImageView()
    
    private var closeButton: ActionButton = {
        let button = ActionButton()
        button.tintColor = .darkGray
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        initConstraints()
        initListeners()
        pictureImageView.isUserInteractionEnabled = true
        let imageTappedGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        pictureImageView.addGestureRecognizer(imageTappedGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage?, index: Int, delegate: PicterCollectionViewCellDelegate) {
        pictureImageView.image = image
        self.index = index
        self.delegate = delegate
    }
    
    private func initUI() {
        backgroundColor = .white
        addSubview(pictureImageView)
        addSubview(closeButton)
        pictureImageView.layer.borderWidth = 1
        pictureImageView.layer.borderColor = UIColor.lightGray.cgColor
        pictureImageView.layer.cornerRadius = 8
    }
    
    private func initConstraints() {
        pictureImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func initListeners() {
        closeButton.touchUp = { [weak self] _ in
            self?.delegate?.deleteImage(with: self?.index)
        }
    }
    
    @objc private func imageTapped() {
        delegate?.openImage(with: index)
    }
}
