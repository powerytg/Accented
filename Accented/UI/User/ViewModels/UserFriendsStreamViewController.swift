//
//  UserFriendsStreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFriendsStreamViewController: InfiniteLoadingViewController<UserModel> {
    private var collection : UserFriendsModel
    
    init(_ collection : UserFriendsModel) {
        self.collection = collection
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createViewModel() {
        viewModel = UserFriendsViewModel(collection: collection, collectionView: collectionView)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 26)
    }
}
