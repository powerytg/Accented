//
//  GalleryStreamViewController.swift
//  Accented
//
//  Gallery photo stream controller
//
//  Created by Tiangong You on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GalleryStreamViewController: StreamViewController {

    var gallery : GalleryModel
    var displayStyle : StreamDisplayStyle
    
    init(gallery : GalleryModel, stream: StreamModel, style : StreamDisplayStyle) {
        self.displayStyle = style
        self.gallery = gallery
        super.init(stream)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createViewModel() {
        if displayStyle == .group {
            viewModel = GalleryStreamViewModel(gallery: gallery, stream: stream, collectionView: collectionView, flowLayoutDelegate: self)
        } else if displayStyle == .card {
            viewModel = GalleryStreamCardViewModel(gallery: gallery, stream: stream, collectionView: collectionView, flowLayoutDelegate: self)
        }
    }
    
    override func streamDidUpdate(_ notification : Notification) -> Void {
        let streamId = notification.userInfo![StorageServiceEvents.streamId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard streamId == stream.streamId else { return }
        
        // Get a new copy of the stream
        let galleryModel = stream as! GalleryStreamModel
        stream = StorageService.sharedInstance.getGalleryPhotoStream(userId: galleryModel.userId, galleryId: galleryModel.galleryId)
        
        if let vm = streamViewModel {
            vm.collecitonDidUpdate(collection: stream, page: page)
        }
    }
}
