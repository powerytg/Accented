//
//  TagSearchResultViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class TagSearchResultViewModel: SingleHeaderStreamViewModel {
    
    override var headerHeight: CGFloat {
        return SingleHeaderStreamLayout.defaultHeaderHeight
    }
    
    override func streamHeader(_ indexPath : IndexPath) -> UICollectionViewCell {
        let searchModel = stream as! PhotoSearchStreamModel
        let streamHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: streamHeaderReuseIdentifier, for: indexPath) as! DefaultSingleStreamHeaderCell
        if stream.loaded {
            streamHeaderCell.isHidden = false
            streamHeaderCell.titleLabel.text = "#\(searchModel.tag!)"
            streamHeaderCell.subtitleLabel.text = "VIEW AS"
            streamHeaderCell.orderButton.setTitle(TextUtils.sortOptionDisplayName(searchModel.sort), for: .normal)
        } else {
            streamHeaderCell.isHidden = true
        }

        return streamHeaderCell
    }
    
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
                })
        } else if let tag = searchModel.tag {
            APIService.sharedInstance.searchPhotos(tag : tag,
                                                   page: page,
                                                   sort : searchModel.sort,
                                                   parameters: params,
                                                   success: nil,
                                                   failure: { [weak self] (errorMessage) in
                                                    self?.collectionFailedRefreshing(errorMessage)
                })
        }
    }
}
