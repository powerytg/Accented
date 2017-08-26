//
//  TagSearchStreamViewController.swift
//  Accented
//
//  Stream view controller for tag search result
//
//  Created by You, Tiangong on 8/26/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class TagSearchStreamViewController: StreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func createViewModel() {
        viewModel = TagSearchResultViewModel(stream: stream, collectionView: collectionView, flowLayoutDelegate: self)
    }
    
    override func streamDidUpdate(_ notification : Notification) -> Void {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard streamId == stream.streamId else { return }
        
        // Get a new copy of the stream
        let searchModel = stream as! PhotoSearchStreamModel
        if let keyword = searchModel.keyword {
            stream = StorageService.sharedInstance.getPhotoSearchResult(keyword: keyword, sort : searchModel.sort)
        } else if let tag = searchModel.tag {
            stream = StorageService.sharedInstance.getPhotoSearchResult(tag: tag, sort : searchModel.sort)
        } else {
            fatalError("Both keyword and tag cannot be nil")
        }
        
        if let vm = streamViewModel {
            vm.collecitonDidUpdate(collection: stream, page: page)
        }
    }
    
    func sortConditionDidChange(sort : PhotoSearchSortingOptions) {
        let searchModel = stream as! PhotoSearchStreamModel
        var newStream : PhotoSearchStreamModel?
        if let keyword = searchModel.keyword {
            newStream = StorageService.sharedInstance.getPhotoSearchResult(keyword: keyword, sort : sort)
        } else if let tag = searchModel.tag {
            newStream = StorageService.sharedInstance.getPhotoSearchResult(tag: tag, sort : sort)
        }
        
        if newStream != nil {
            switchStream(newStream!)
        }
    }
}
