//
//  CommentsViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class CommentsViewModel : InfiniteLoadingViewModel<CommentModel>, CommentsLayoutDelegate {

    static let darkCellIdentifier = "darkCell"
    static let lightCellIdentifier = "lightCell"

    // Collection view layout
    var commentsLayout : CommentsLayout {
        return layout as! CommentsLayout
    }
    
    override init(collection: CollectionModel<CommentModel>, collectionView: UICollectionView) {
        super.init(collection: collection, collectionView: collectionView)
        
        // Register cell types
        collectionView.register(DetailCommentCell.self, forCellWithReuseIdentifier: CommentsViewModel.darkCellIdentifier)
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(photoCommentsDidChange(_:)), name: StorageServiceEvents.photoCommentsDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didPostComment(_:)), name: StorageServiceEvents.didPostComment, object: nil)
    }
    
    override func createCollectionViewLayout() {
        layout = CommentsLayout()
        commentsLayout.delegate = self
        layout.collection = collection
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func photoCommentsDidChange(_ notification : Notification) {
        let updatedPhotoId = notification.userInfo![StorageServiceEvents.photoId] as! String
        let page = notification.userInfo![StorageServiceEvents.page] as! Int
        guard updatedPhotoId == collection.modelId else { return }
        
        // Get a new copy of the comment collection
        collection = StorageService.sharedInstance.getComments(collection.modelId!)
        updateCollectionView(page == 1)
        streamState.loading = false
        
        if page == 1 {
            streamState.refreshing = false
            delegate?.viewModelDidRefresh()
        }
    }
    
    @objc fileprivate func didPostComment(_ notification : Notification) {
        let updatedPhotoId = notification.userInfo![StorageServiceEvents.photoId] as! String
        guard updatedPhotoId == collection.modelId else { return }

        // Get a new copy of the comment collection
        collection = StorageService.sharedInstance.getComments(collection.modelId!)
        updateCollectionView(false)
    }
    
    override func loadPageAt(_ page : Int) {
        APIService.sharedInstance.getComments(collection.modelId!, page: page, parameters: [String : String](), success: nil) { [weak self] (errorMessage) in
            self?.collectionFailedLoading(errorMessage)
        }        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsViewModel.darkCellIdentifier, for: indexPath) as! DetailCommentCell
        cell.comment = collection.items[indexPath.item]
        cell.style = cellStyleForItemAtIndexPath(indexPath)
        cell.setNeedsLayout()
        return cell
    }
    
    // MARK: - CommentsLayoutDelegate
    func cellStyleForItemAtIndexPath(_ indexPath: IndexPath) -> CommentRendererStyle {
        return (indexPath.item % 2 == 0 ? .Dark : .Light)
    }
}
