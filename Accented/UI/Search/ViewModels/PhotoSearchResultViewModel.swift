//
//  PhotoSearchResultViewModel.swift
//  Accented
//
//  Photo search result view model
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import RMessage

class PhotoSearchResultViewModel: HeaderlessStreamViewModel {
    // MARK: - Loading
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        let searchModel = stream as! PhotoSearchStreamModel
        if let keyword = searchModel.keyword {
            APIService.sharedInstance.searchPhotos(keyword : keyword,
                                                   page: page,
                                                   sort : searchModel.sort,
                                                   parameters: params,
                                                   success: nil,
                                                   failure: { [weak self] (errorMessage) in
                                                    self?.collectionFailedRefreshing(errorMessage)
                                                    RMessage.showNotification(withTitle: errorMessage, subtitle: nil, type: .error, customTypeName: nil, callback: nil)
            })
        } else if let tag = searchModel.tag {
            APIService.sharedInstance.searchPhotos(tag : tag,
                                                   page: page,
                                                   sort : searchModel.sort,
                                                   parameters: params,
                                                   success: nil,
                                                   failure: { [weak self] (errorMessage) in
                                                    self?.collectionFailedRefreshing(errorMessage)
                                                    RMessage.showNotification(withTitle: errorMessage, subtitle: nil, type: .error, customTypeName: nil, callback: nil)
            })
        }
    }
}
