//
//  UserFriendsViewModel.swift
//  Accented
//
//  View model of user's friend list
//
//  Created by Tiangong You on 9/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserFriendsViewModel: InfiniteLoadingViewModel<UserModel>  {
    
    private let rendererIdentifier = "renderer"
    
    required init(collection : UserFriendsModel, collectionView : UICollectionView) {
        super.init(collection: collection, collectionView: collectionView)
        
        let rendererNib = UINib(nibName: "UserSearchResultRenderer", bundle: nil)
        collectionView.register(rendererNib, forCellWithReuseIdentifier: rendererIdentifier)
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(userFriendsDidUpdate(_:)), name: StorageServiceEvents.userFriendsDidUpdate, object: nil)
        
        // Load first page
        loadIfNecessary()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func createCollectionViewLayout() {
        let userLayout = UserSearchResultLayout()
        userLayout.paddingTop = 90
        layout = userLayout
    }
    
    override func loadPageAt(_ page : Int) {
        APIService.sharedInstance.getUserFriends(userId: collection.modelId!, page: page, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedLoading(errorMessage)
        }
    }
    
    // Events
    @objc private func userFriendsDidUpdate(_ notification : Notification) {
        let updatedUserId = notification.userInfo![StorageServiceEvents.userId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard updatedUserId == collection.modelId else { return }
        
        // Get a new copy of the user friends
        collection = StorageService.sharedInstance.getUserFriends(userId: collection.modelId!)
        updateCollectionView(page == 1)
        streamState.loading = false
        
        if page == 1 {
            streamState.refreshing = false
            delegate?.viewModelDidRefresh()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !collection.loaded {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
            return loadingCell
        } else {
            let user = collection.items[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rendererIdentifier, for: indexPath) as! UserSearchResultRenderer
            cell.user = user
            cell.setNeedsLayout()
            return cell
        }
    }
}
