//
//  GalleryStreamViewModel.swift
//  Accented
//
//  Created by Tiangong You on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import RMessage

class GalleryStreamViewModel: SingleHeaderStreamViewModel {
    var gallery : GalleryModel
    
    override var headerHeight: CGFloat {
        return UserStreamLayoutSpec.streamHeaderHeight
    }
    
    required init(gallery : GalleryModel, stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        self.gallery = gallery
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    required init(stream: StreamModel, collectionView: UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        fatalError("init(stream:collectionView:flowLayoutDelegate:) has not been implemented")
    }
    
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        APIService.sharedInstance.getGalleryPhotos(userId: gallery.userId, galleryId: gallery.galleryId, page: page, parameters: params, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedRefreshing(errorMessage)
            RMessage.showNotification(withTitle: errorMessage, subtitle: nil, type: .error, customTypeName: nil, callback: nil)
        }
    }
    
    override func streamHeader(_ indexPath : IndexPath) -> UICollectionViewCell {
        let streamHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: streamHeaderReuseIdentifier, for: indexPath) as! DefaultSingleStreamHeaderCell
        streamHeaderCell.titleLabel.text = gallery.name.uppercased()
        
        if let photoCount = gallery.totalCount {
            if photoCount == 0 {
                streamHeaderCell.subtitleLabel.text = "NO ITEMS"
            } else if photoCount == 1 {
                streamHeaderCell.subtitleLabel.text = "1 ITEM"
            } else {
                streamHeaderCell.subtitleLabel.text = "\(photoCount) ITEMS"
            }
        } else {
            streamHeaderCell.subtitleLabel.isHidden = true
        }
        
        streamHeaderCell.orderLabel.isHidden = true
        streamHeaderCell.orderButton.isHidden = true
        return streamHeaderCell
    }
}
