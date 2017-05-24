//
//  UserSearchResultViewModel.swift
//  Accented
//
//  Created by Tiangong You on 5/22/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserSearchResultViewModel: InfiniteLoadingViewModel {
    /*
    fileprivate let rendererIdentifier = "renderer"
    fileprivate let initialLoadingRendererReuseIdentifier = "initialLoading"
    fileprivate let loadingFooterRendererReuseIdentifier = "loadingFooter"
    
    // Search result model
    fileprivate var stream : UserSearchResultModel
    
    // Inline infinite loading cell
    var loadingCell : DefaultStreamInlineLoadingCell?
    required init(stream : UserSearchResultModel, collectionView : UICollectionView) {
        self.stream = stream
        super.init(collectionView)
        
        let rendererNib = UINib(nibName: "UserSearchResultRenderer", bundle: nil)
        collectionView.register(rendererNib, forCellWithReuseIdentifier: rendererIdentifier)
        
        // Inline loading
        let loadingCellNib = UINib(nibName: "DefaultStreamInlineLoadingCell", bundle: nil)
        collectionView.register(loadingCellNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier)
        
        // Initial loading
        let initialLoadingCellNib = UINib(nibName: "DefaultStreamInitialLoadingCell", bundle: nil)
        collectionView.register(initialLoadingCellNib, forCellWithReuseIdentifier: initialLoadingRendererReuseIdentifier)
        
        // Create layout
        let layout = UserSearchResultLayout(width: collectionView.bounds.size.width)
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !stream.loaded {
            let loadingCell = collectionView.dequeueReusableCell(withReuseIdentifier: initialLoadingRendererReuseIdentifier, for: indexPath)
            return loadingCell
        } else {
            let user = stream.users[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rendererIdentifier, for: indexPath) as! UserSearchResultRenderer
            cell.user = user
            cell.setNeedsLayout()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            // If the stream has more content, show the loading cell for the last section
            let totalSectionCount = self.numberOfSections(in: collectionView)
            if (indexPath as NSIndexPath).section == totalSectionCount - 1 && canLoadMore() {
                let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: loadingFooterRendererReuseIdentifier, for: indexPath) as! DefaultStreamInlineLoadingCell
                loadingView.streamViewModel = self
                
                // If there are no more items in the stream to load, show the ending status
                if stream.users.count >= stream.totalCount! {
                    loadingView.showEndingState()
                } else {
                    // Otherwise, always show the loading state, even if the previous attempt of loading failed. This is because we'll trigger loadNextPage() regardless of footer state
                    loadingView.showLoadingState()
                }
                
                self.loadingCell = loadingView
                return loadingView
            } else {
                // If we can no longer load, then return an empty view as footer
                return UICollectionViewCell()
            }
        }
        
        return UICollectionViewCell()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !stream.loaded {
            return 1
        } else {
            return stream.users.count
        }
    }
    
    // MARK: - Events
    
    fileprivate func streamFailedLoading(_ error: String) {
        debugPrint(error)
        streamState.loading = false

        if let loadingView = self.loadingCell {
            loadingView.showRetryState()
        }
    }
    
    // MARK: - Private
    
    fileprivate func canLoadMore() -> Bool {
        return stream.totalCount! > stream.users.count
    }
 */
}
