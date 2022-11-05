//
//  PicturesViewController.swift
//  DrawApplication
//
//  Created by Рамил Гаджиев on 02.11.2022.
//

import UIKit

class PicturesViewController: UIViewController {
    private var pictureitems: [PictureItem] = [] {
        didSet {
            itemsIsEmptyBtn.isHidden = pictureitems.isEmpty ? false : true
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collectionLayout.scrollDirection = .vertical
        collection.register(PicterCollectionViewCell.self, forCellWithReuseIdentifier: PicterCollectionViewCell.identifier)
        return collection
    }()
    
    private var itemsIsEmptyBtn: ActionButton = {
        let button = ActionButton()
        button.setTitle("Нарисовать изображение", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.layer.cornerRadius = 6
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initConstraints()
        initListeners()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toDraw))
    }
    
    private func initUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(itemsIsEmptyBtn)
        title = "Альбом"
    }
    
    private func initConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        
        itemsIsEmptyBtn.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.right.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    private func initListeners() {
        itemsIsEmptyBtn.touchUp = { [weak self] _ in
            self?.toDraw()
        }
    }
    
    @objc private func toDraw() {
        let drawVC = DrawViewController()
        drawVC.delegate = self
        navigationController?.pushViewController(drawVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictureitems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicterCollectionViewCell.identifier, for: indexPath) as? PicterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: pictureitems[indexPath.row].image, index: indexPath.row, delegate: self)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = UIScreen.main.bounds.width/2 - 8 - 16
        return CGSize(width: side, height: side)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}

// MARK: - DrawViewControllerDelegate
extension PicturesViewController: DrawViewControllerDelegate {
    func savePicture(index: Int?, image: UIImage?, layout: Layout?) {
        if let index = index, index < pictureitems.count {
            pictureitems[index].layout = layout
            pictureitems[index].image = image
            collectionView.reloadData()
            return
        }
        let pictureItem = PictureItem(id: UUID(), image: image, layout: layout)
        pictureitems.insert(pictureItem, at: 0)
        collectionView.reloadData()
    }
}

// MARK: - PicterCollectionViewCellDelegate
extension PicturesViewController: PicterCollectionViewCellDelegate {
    func openImage(with index: Int?) {
        let pictureitem = pictureitems[index!]
        let drawVC = DrawViewController(index: index, layout: pictureitem.layout)
        drawVC.delegate = self
        navigationController?.pushViewController(drawVC, animated: true)
    }
    
    func deleteImage(with index: Int?) {
        guard let index = index else { return }
        let alert = UIAlertController(title: "Удалить изображение?", message: "", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.removePicture(with: index)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func removePicture(with index: Int) {
        collectionView.performBatchUpdates {
            pictureitems.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        } completion: { _ in
            self.collectionView.reloadData()
        }
    }
}
