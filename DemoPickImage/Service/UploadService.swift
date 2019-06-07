//
//  UploadService.swift
//  DemoPickImage
//
//  Created by ly.hoang.quang on 6/7/19.
//  Copyright © 2019 ly.hoang.quang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UploadService {
    private let url = "https://api.imgur.com/3/image"
    private let clientID = "c5d1c2185e54a45"
    
    static let shared: UploadService = UploadService()
    
    private init() {}
    
    func uploadImage(image: UIImage, completion: @escaping ((BaseModel?) -> Void)) {
        let header: HTTPHeaders = [
            "Content-type" : "multipart/form-data",
            "Authorization" : "Client-ID \(clientID)"
        ]
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData,
                                     withName: "image",
                                     fileName: "image.jpg",
                                     mimeType: "image/jpg")
        }, to: url, method: .post, headers: header) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    let json = JSON(response.data as Any)
                    let baseModel = BaseModel(json: json)
                    if baseModel.success {
                        completion(ResultModel(json: json))
                    } else {
                        completion(ErrorModel(json: json))
                    }
                })
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
