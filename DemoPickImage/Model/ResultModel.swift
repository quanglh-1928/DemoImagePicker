//
//  ResultModel.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/7/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResultModel: BaseModel {
    var id: String = ""
    var title: String = ""
    var name: String = ""
    var link: String = ""
    
    override init(json: JSON) {
        super.init(json: json)
        id = json["data"]["id"].stringValue
        title = json["data"]["title"].stringValue
        name = json["data"]["name"].stringValue
        link = json["data"]["link"].stringValue
    }
}
