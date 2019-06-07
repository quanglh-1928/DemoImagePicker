//
//  BaseModel.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/7/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseModel {
    var success: Bool
    
    init(json: JSON) {
        success = json["success"].boolValue
    }
}
