//
//  APIService+Photos.swift
//  Accented
//
//  Created by Tiangong You on 8/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import OAuthSwift

extension APIService {
    func uploadPhoto(name : String, description : String, category : Category, privacy : Privacy, image : Data, success: (() -> Void)? = nil, failure : ((String) -> Void)? = nil) {
        let request = UploadPhotoRequest(name: name, description: description, category: category, privacy: privacy, image: image, success: success, failure: failure)
        
        let photoData = OAuthSwiftMultipartData(name: "file", data: image, fileName: "test_photo.jpg", mimeType: "image/jpeg")
        let nameData = OAuthSwiftMultipartData(name: "name", data: name.data(using: .utf8)!, fileName: nil, mimeType: "multipart/form-data")
        let descData = OAuthSwiftMultipartData(name: "description", data: description.data(using: .utf8)!, fileName: nil, mimeType: "multipart/form-data")
        
        let categoryData = OAuthSwiftMultipartData(name: "category", data: String(category.rawValue).data(using: .utf8)!, fileName: nil, mimeType: "multipart/form-data")
        let privacyData = OAuthSwiftMultipartData(name: "privacy", data: String(privacy.rawValue).data(using: .utf8)!, fileName: nil, mimeType: "multipart/form-data")
        
        let multiparts = [nameData, descData, categoryData, privacyData, photoData]
        _ = client.postMultiPartRequest(request.url, method: .POST, parameters: [String:String](), headers: nil, multiparts: multiparts, checkTokenExpiration: false, success: { (response) in
            request.handleSuccess(data: response.data, response: response.response)
        }, failure: { (error) in
            request.handleFailure(error)
        })
    }
}
