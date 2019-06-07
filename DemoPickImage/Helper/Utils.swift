//
//  Utils.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/5/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import Photos

class Utils {
    static func showErrorAlert(title: String? = nil, message: String, from vc: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
    
    static func getAssetThumbnail(asset: PHAsset, size: CGFloat) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize.init(width: size * retinaScale, height: size * retinaScale)
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, _) -> Void in
            if let thumbnailImage = result {
                thumbnail = thumbnailImage
            }
            
        })
        return thumbnail
    }
    
    static func getAssetImage(asset: PHAsset) -> UIImage {
        var img: UIImage = UIImage()
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data) ?? UIImage()
            }
        }
        return img
    }
}
