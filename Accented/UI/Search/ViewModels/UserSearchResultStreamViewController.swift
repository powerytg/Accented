//
//  UserSearchResultStreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/24/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSearchResultStreamViewController: InfiniteLoadingViewController<UserModel> {
    
    fileprivate var collection : UserSearchResultModel
    
    init(_ collection : UserSearchResultModel) {
        self.collection = collection
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createViewModel() {
        viewModel = UserSearchResultViewModel(collection: collection, collectionView: collectionView)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 26)
    }    
}
