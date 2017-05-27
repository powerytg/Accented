//
//  UserSearchResultViewModel.swift
//  Accented
//
//  User search result stream view model
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSearchResultViewModel : InfiniteLoadingViewModel<UserModel> {
    
    fileprivate let rendererIdentifier = "renderer"
    
    required init(collection : UserSearchResultModel, collectionView : UICollectionView) {
        super.init(collection: collection, collectionView: collectionView)
        
        let rendererNib = UINib(nibName: "UserSearchResultRenderer", bundle: nil)
        collectionView.register(rendererNib, forCellWithReuseIdentifier: rendererIdentifier)
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(userSearchResultDidUpdate(_:)), name: StorageServiceEvents.userSearchResultDidUpdate, object: nil)
        
        // Load first page
        loadIfNecessary()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func createCollectionViewLayout() {
        layout = UserSearchResultLayout()
    }
    
    override func loadPageAt(_ page : Int) {
        APIService.sharedInstance.searchUsers(keyword: collection.modelId!, page: page, success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedLoading(errorMessage)
        }
    }

    // Events
    @objc fileprivate func userSearchResultDidUpdate(_ notification : Notification) {
        let updatedKeyword = notification.userInfo![StorageServiceEvents.keyword] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard updatedKeyword == collection.modelId else { return }
        
        // Get a new copy of the search results
        collection = StorageService.sharedInstance.getUserSearchResult(keyword: collection.modelId!)
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
