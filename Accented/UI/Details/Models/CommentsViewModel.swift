//
//  CommentsViewModel.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class CommentsViewModel: InfiniteLoadingViewModel, CommentsLayoutDelegate {

    static let darkCellIdentifier = "darkCell"
    static let lightCellIdentifier = "lightCell"

    fileprivate var photoId : String!
    fileprivate var comments = [CommentModel]()
    fileprivate var photo : PhotoModel!
    
    // Collection view layout
    var layout = CommentsLayout()
    
    init(_ photoId : String, collectionView : UICollectionView) {
        self.photoId = photoId
        super.init(collectionView)
        
        initialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func initialize() {
        photo = StorageService.sharedInstance.photoCache.object(forKey: NSString(string :photoId))
        comments = photo!.comments

        // Register cell types
        collectionView.register(DetailCommentCell.self, forCellWithReuseIdentifier: CommentsViewModel.darkCellIdentifier)

        // Initialize layout
        layout.delegate = self
        layout.comments = comments
        collectionView.collectionViewLayout = layout
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(photoCommentsDidChange(_:)), name: StorageServiceEvents.photoCommentsDidUpdate, object: nil)
    }
    
    override func refresh() {
        if streamState.refreshing {
            return
        }
        
        streamState.refreshing = true
        let page = 1
        APIService.sharedInstance.getComments(photoId, page: page, parameters: [:], success: nil) { [weak self] (errorMessage) in
            self?.streamFailedRefreshing(errorMessage)
        }
    }
    
    override func loadNextPage() {
        if streamState.loading {
            return
        }
        
        streamState.loading = true
        let page = photo.comments.count / StorageService.pageSize + 1
        APIService.sharedInstance.getComments(photoId, page: page, parameters: [:], success: nil) { [weak self] (errorMessage) in
            self?.streamFailedLoading(errorMessage)
        }
    }
    
    @objc fileprivate func photoCommentsDidChange(_ notification : Notification) {
        let photoId = (notification as NSNotification).userInfo![StorageServiceEvents.photoId] as! String
        let page = (notification as NSNotification).userInfo![StorageServiceEvents.page] as! Int
        guard photo != nil else { return }
        guard photo!.photoId == photoId else { return }

        updateCollectionView(page == 1)        
        streamState.loading = false
        
        if page == 1 {
            streamState.refreshing = false
            delegate?.viewModelDidRefresh()
        }
    }
    
    func clearCollectionView() {
        comments.removeAll()
        layout.clearLayoutCache()
    }

    override func updateCollectionView(_ shouldRefresh : Bool) {
        // If stream needs refresh (page is 1), then clear all the previous layout metadata and group info
        if shouldRefresh {
            clearCollectionView()
        }
        
        // Update the collection view
        comments = photo.comments
        layout.comments = comments
        layout.generateLayoutAttributesIfNeeded()
        collectionView.reloadData()
    }
    
    @objc fileprivate func streamFailedLoading(_ error : String) {
        debugPrint(error)
        streamState.loading = false
    }
    
    @objc fileprivate func streamFailedRefreshing(_ error : String) {
        debugPrint(error)
        streamState.refreshing = false
    }

    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentsViewModel.darkCellIdentifier, for: indexPath) as! DetailCommentCell
        cell.comment = comments[indexPath.item]
        cell.style = cellStyleForItemAtIndexPath(indexPath)
        cell.setNeedsLayout()
        return cell
    }
    
    // MARK: - CommentsLayoutDelegate
    func cellStyleForItemAtIndexPath(_ indexPath: IndexPath) -> CommentRendererStyle {
        return (indexPath.item % 2 == 0 ? .Dark : .Light)
    }
}
