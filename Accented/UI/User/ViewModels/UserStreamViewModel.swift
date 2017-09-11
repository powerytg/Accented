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
import RMessage

class UserStreamViewModel : SingleHeaderStreamViewModel{

    var user : UserModel

    override var headerHeight: CGFloat {
        return UserStreamLayoutSpec.streamHeaderHeight
    }
    
    required init(user : UserModel, stream : StreamModel, collectionView : UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        self.user = user
        super.init(stream: stream, collectionView: collectionView, flowLayoutDelegate: flowLayoutDelegate)
    }
    
    required init(stream: StreamModel, collectionView: UICollectionView, flowLayoutDelegate: UICollectionViewDelegateFlowLayout) {
        fatalError("init(stream:collectionView:flowLayoutDelegate:) has not been implemented")
    }
    
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        let userStreamModel = stream as! UserStreamModel
        APIService.sharedInstance.getUserPhotos(userId: userStreamModel.userId, page: page, parameters: params, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedRefreshing(errorMessage)
            RMessage.showNotification(withTitle: errorMessage, subtitle: nil, type: .error, customTypeName: nil, callback: nil)
        }
    }
    
    override func streamHeader(_ indexPath : IndexPath) -> UICollectionViewCell {
        let streamHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: streamHeaderReuseIdentifier, for: indexPath) as! DefaultSingleStreamHeaderCell
        let userName = TextUtils.preferredAuthorName(user).uppercased()
        streamHeaderCell.titleLabel.text = "\(userName)'S \nPUBLIC PHOTOS"
        
        if let photoCount = user.photoCount {
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
        
        streamHeaderCell.orderButton.isHidden = true
        streamHeaderCell.orderLabel.isHidden = true
        return streamHeaderCell
    }

}
