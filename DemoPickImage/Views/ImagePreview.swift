//
//  ImagePreview.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/6/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

protocol ImagePreviewDelegate: class {
    func done(image: UIImage)
}

class ImagePreview: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    weak var delegate: ImagePreviewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ImagePreview", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setImage(image: UIImage) {
        previewImageView.image = image
    }

    @IBAction func onDone(_ sender: Any) {
        delegate?.done(image: previewImageView.image ?? UIImage())
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.isHidden = true
    }
}
