//
//  DetailImageCell.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/6/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

class DetailImageCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupScrollView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = 1.0
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.zoomScale = 1.0
    }
    
    func config(image: UIImage) {
        photoImageView.image = image
    }
    
}

extension DetailImageCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
}
