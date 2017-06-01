//
//  UserStreamViewModel.swift
//  Accented
//
//  User stream photos
//
//  Created by Tiangong You on 5/31/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserStreamViewModel : PhotoSearchResultViewModel{
    
    // MARK: - Loading
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        let userStreamModel = stream as! UserStreamModel
        APIService.sharedInstance.getUserPhotos(userId: userStreamModel.userId, page: page, parameters: params, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedRefreshing(errorMessage)
        }
    }
}
