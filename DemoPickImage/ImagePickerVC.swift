//
//  ImagePickerVC.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/5/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerDelegate: class {
    func done(with image: UIImage)
}

class ImagePickerVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    private var imageListAsset: [PHAsset] = []
    private var selectedAsset: PHAsset?
    private var selectedIndex: Int = -1
    private var justSelecIndex: Int = -1
    private var mode: ImageMode = .view
    
    weak var delegate: ImagePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        checkPermission()
        getAllImage()
    }
    
    private func checkPermission() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined || authStatus == .denied {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                    self.getAllImage()
                } else {
                    Utils.showErrorAlert(message: "Bạn chưa cấp quyền truy cập Photos", from: self)
                }
            })
        }
    }
    
    func getAllImage() {
        let allPhotoOption = PHFetchOptions()
        allPhotoOption.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: allPhotoOption)
        for i in 0..<fetchResult.count {
            imageListAsset.append(fetchResult[i])
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func removeSelected() {
        selectedIndex = -1
        selectedAsset = nil
        justSelecIndex = -1
    }
    
    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSwitchMode(_ sender: UISwitch) {
        mode = sender.isOn ? .select : .view
        if let cell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? ImageCell {
            cell.config(isSelected: false)
        }
        removeSelected()
    }
    
    @IBAction func onDone(_ sender: Any) {
        guard let selectedAsset = self.selectedAsset else { return }
        DispatchQueue.main.async {
            let image = Utils.getAssetThumbnail(asset: selectedAsset, size: 300)
            self.delegate?.done(with: image)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ImagePickerVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageListAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        DispatchQueue.main.async {
            cell.config(image: Utils.getAssetThumbnail(asset: self.imageListAsset[indexPath.row], size: 80),
                        isSelected: self.selectedIndex == indexPath.row)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagePickerVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 5.0
        let width = (view.bounds.width - 5 * space) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !imageListAsset.isEmpty else { return }
        switch mode {
        case .select:
            selectOnSelectMode(collectionView, at: indexPath)
        case .view:
            selectOnViewMode(collectionView, at: indexPath)
        }
    }
    
    private func selectOnSelectMode(_ collectionView: UICollectionView, at indexPath: IndexPath) {
        selectedAsset = imageListAsset[indexPath.row]
        justSelecIndex = selectedIndex
        selectedIndex = indexPath.row
        if justSelecIndex == selectedIndex {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? ImageCell else { return }
            cell.config(isSelected: false)
            removeSelected()
        } else {
            guard let cell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as? ImageCell else { return}
            cell.config(isSelected: true)
            guard let justCell = collectionView.cellForItem(at: IndexPath(row: justSelecIndex, section: 0)) as? ImageCell else { return}
            justCell.config(isSelected: false)
        }
    }
    
    private func selectOnViewMode(_ collectionView: UICollectionView, at indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailImageVC") as? DetailImageVC {
            detailVC.imageAssets = self.imageListAsset
            detailVC.selectedIndex = indexPath
            detailVC.modalPresentationStyle = .overCurrentContext
            present(detailVC, animated: true, completion: nil)
        }
    }
}
