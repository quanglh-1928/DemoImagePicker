//
//  ImageCell.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/5/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var tickIcon: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tickIcon.isHidden = true
        layer.cornerRadius = 5
    }
    
    func config(image: UIImage? = nil, isSelected: Bool) {
        if let image = image {
            photoImageView.image = image
        }
        tickIcon.isHidden = !isSelected
    }
    
}
