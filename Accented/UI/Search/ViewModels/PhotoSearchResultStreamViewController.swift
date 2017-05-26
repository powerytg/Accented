//
//  PhotoSearchResultStreamViewController.swift
//  Accented
//
//  Photo search result stream controller
//
//  Created by Tiangong You on 5/21/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoSearchResultStreamViewController: StreamViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func createViewModel() {
        viewModel = PhotoSearchResultViewModel(stream: stream, collectionView: collectionView, flowLayoutDelegate: self)
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
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 8)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 26)
    }
}
