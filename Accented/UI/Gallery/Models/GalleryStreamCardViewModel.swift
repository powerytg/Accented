//
//  GalleryStreamCardViewModel.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GalleryStreamCardViewModel: SingleHeaderStreamViewModel {
    
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

    override var cardRendererReuseIdentifier : String {
        return "cardRenderer"
    }
    
    override func registerCellTypes() {
        super.registerCellTypes()
        collectionView.register(StreamCardPhotoCell.self, forCellWithReuseIdentifier: cardRendererReuseIdentifier)
    }
    
    override func createLayoutTemplateGenerator(_ maxWidth: CGFloat) -> StreamTemplateGenerator {
        return PhotoCardTemplateGenerator(maxWidth: maxWidth)
    }
    
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        APIService.sharedInstance.getGalleryPhotos(userId: gallery.userId, galleryId: gallery.galleryId, page: page, parameters: params, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedRefreshing(errorMessage)
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
