//
//  ErrorModel.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/7/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import Foundation
import SwiftyJSON

class ErrorModel: BaseModel {
    var error: String = ""
    var status: Int = 0
    
    override init(json: JSON) {
        super.init(json: json)
        error = json["data"]["error"].stringValue
        status = json["status"].intValue
    }
}
