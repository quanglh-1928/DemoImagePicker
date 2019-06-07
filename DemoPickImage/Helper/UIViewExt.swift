//
//  UIViewExt.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/6/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit

extension UIView {
    func toImage() -> UIImage? {
        var image: UIImage
        
        UIGraphicsBeginImageContext(self.frame.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
