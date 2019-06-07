//
//  DetailImageVC.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/6/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import Photos

class DetailImageVC: PannableVC {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageAssets: [PHAsset] = []
    var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        collectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
    }
    
    func setupUI() {
        collectionView.register(UINib(nibName: "DetailImageCell", bundle: nil), forCellWithReuseIdentifier: "DetailImageCell")
    }

}

// MARK: - UICollectionViewDataSource
extension DetailImageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailImageCell", for: indexPath) as? DetailImageCell else { return UICollectionViewCell() }
        DispatchQueue.main.async {
            cell.config(image: Utils.getAssetThumbnail(asset: self.imageAssets[indexPath.row], size: 300))
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailImageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
