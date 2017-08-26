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

class UserStreamViewModel : SingleHeaderStreamViewModel{

    private let streamHeaderIdentifier = "streamHeader"

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
    
    override func registerCellTypes() {
        super.registerCellTypes()
        
        let streamHeaderNib = UINib(nibName: "UserStreamHeaderCell", bundle: nil)
        collectionView.register(streamHeaderNib, forCellWithReuseIdentifier: streamHeaderIdentifier)
    }
    
    override func loadPageAt(_ page : Int) {
        let params = ["tags" : "1"]
        let userStreamModel = stream as! UserStreamModel
        APIService.sharedInstance.getUserPhotos(userId: userStreamModel.userId, page: page, parameters: params, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedRefreshing(errorMessage)
        }
    }
    
    override func streamHeader(_ indexPath : IndexPath) -> UICollectionViewCell {
        let streamHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: streamHeaderIdentifier, for: indexPath) as! UserStreamHeaderCell
        streamHeaderCell.user = user
        return streamHeaderCell
    }
    
}
