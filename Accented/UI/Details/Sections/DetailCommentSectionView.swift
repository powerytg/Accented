//
//  DetailCommentSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentSectionView: DetailSectionViewBase {

    override var sectionId: String {
        return "comments"
    }

    fileprivate var contentRightMargin : CGFloat = 50
    fileprivate let contentLeftMargin : CGFloat = 24
    fileprivate var contentTopMargin : CGFloat = 0
    fileprivate var contentBottomMargin : CGFloat = 15
    
    fileprivate let noCommentsText = "This photo does not have comments"
    fileprivate let loadingText = "Loading comments..."
    fileprivate let errorText = "Could not retrieve comments"
    
    fileprivate let textFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
    override var title: String? {
        return "COMMENTS"
    }
    
    // Status label will be visible if there are no comments, or if the comments are being loaded
    fileprivate var statusLabel = UILabel()
    fileprivate var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    // Cached section height
    fileprivate var calculatedSectionHeight : CGFloat = 0
    
    // Fixed content height when there're no comments in the photo
    fileprivate var noCommentsSectionHeight : CGFloat = 40
    
    // Comment renderer vertical padding
    private var vPadding : CGFloat = 10
    
    // Comment renderer indention
    private var indention : CGFloat = 12
    
    // Load-more button top margin
    fileprivate var loadMoreMarginTop : CGFloat = 10
    
    // Maximum number of comments pre-created
    fileprivate let maxNumberOfCommentsOnScreen = 4
    
    // Comment renderers
    fileprivate var commentRenderers = [CommentRenderer]()
    
    // Load more button
    fileprivate let loadMoreButton = UIButton(type: UIButtonType.custom)
    
    // Comment collection
    fileprivate var commentCollection : CommentCollectionModel!
    
    override func initialize() {
        super.initialize()
        
        // Status label
        contentView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - contentRightMargin
        statusLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        statusLabel.font = textFont
        statusLabel.isHidden = true
        
        // Loading spinner
        contentView.addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.isHidden = true
        
        // Create a limited number of comment renderers ahead of time
        for index in 1...maxNumberOfCommentsOnScreen {
            let style : CommentRendererStyle = (index % 2 == 0 ? .Dark : .Light)
            let renderer = CommentRenderer(style)
            contentView.addSubview(renderer)
            commentRenderers.append(renderer)
            renderer.isHidden = true
        }
        
        // Create a load-more button
        loadMoreButton.titleLabel?.font = ThemeManager.sharedInstance.currentTheme.navButtonFont
        loadMoreButton.setTitle("See more comments", for: .normal)
        loadMoreButton.sizeToFit()
        loadMoreButton.isHidden = true
        contentView.addSubview(loadMoreButton)
        
        // Constraints
        statusLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: contentLeftMargin).isActive = true
        statusLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentTopMargin).isActive = true
        
        loadingSpinner.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 15).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
        
        // Events
        loadMoreButton.addTarget(self, action: #selector(navigateToCommentsPage(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(photoCommentsDidChange(_:)), name: StorageServiceEvents.photoCommentsDidUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func photoModelDidChange() {
        // Stop loading spinner
        loadingSpinner.stopAnimating()
        
        // Refresh the photo comments in background
        guard photo != nil else { return }
        APIService.sharedInstance.getComments(photo!.photoId)

        // Get a copy of the comments
        self.commentCollection = StorageService.sharedInstance.getComments(photo!.photoId)
        setNeedsLayout()
    }
    
    @objc fileprivate func navigateToCommentsPage(_ sender : NSObject) {
        NavigationService.sharedInstance.navigateToCommentsPage(photo!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }
        
        if commentCollection.totalCount == 0 {
            // Photo has no comments
            statusLabel.text = noCommentsText
            statusLabel.isHidden = false
            loadingSpinner.isHidden = true
            loadMoreButton.isHidden = true
        } else if commentCollection.items.count == 0 {
            // Photo has comments, but have yet loaded
            statusLabel.text = loadingText
            statusLabel.isHidden = false
            loadingSpinner.isHidden = false
            loadMoreButton.isHidden = true
            loadingSpinner.startAnimating()
        } else {
            // Showing the top comments
            statusLabel.isHidden = true
            loadingSpinner.isHidden = true
            loadMoreButton.isHidden = false
            
            var nextY : CGFloat = 0
            for (index, renderer) in commentRenderers.enumerated() {
                if index < commentCollection.items.count {
                    let comment = commentCollection.items[index]
                    let rendererMaxWidth = maxWidthForRendererAtIndex(index)
                    let rendererSize = estimatedSizeForComment(comment, maxWidth: rendererMaxWidth)
                    renderer.frame = CGRect(x: leftMarginForRendererAtIndex(index), y: nextY, width: rendererSize.width, height: rendererSize.height)
                    renderer.comment = commentCollection.items[index]
                    renderer.isHidden = false
                    
                    nextY += rendererSize.height + vPadding
                } else {
                    renderer.isHidden = true
                }
            }
            
            var f = loadMoreButton.frame
            f.origin.x = contentLeftMargin
            f.origin.y = nextY + loadMoreMarginTop
            loadMoreButton.frame = f
        }
    }
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        // Get a copy of the comments
        self.commentCollection = StorageService.sharedInstance.getComments(photo.photoId)

        if commentCollection.totalCount == 0 || commentCollection.items.count == 0 {
            return sectionTitleHeight + noCommentsSectionHeight
        } else {
            var calculatedHeight : CGFloat = 0
            let displayCommentsCount = min(commentCollection.items.count, maxNumberOfCommentsOnScreen)
            for index in 0...(displayCommentsCount - 1) {
                let comment = commentCollection.items[index]
                let rendererMaxWidth = maxWidthForRendererAtIndex(index)
                let commentHeight = estimatedSizeForComment(comment, maxWidth: rendererMaxWidth).height
                
                calculatedHeight += commentHeight
            }
            
            calculatedHeight += vPadding * CGFloat(displayCommentsCount - 1)
            calculatedHeight += loadMoreButton.frame.size.height + loadMoreMarginTop
            return calculatedHeight + sectionTitleHeight
        }
    }
    
    private func leftMarginForRendererAtIndex(_ index : Int) -> CGFloat {
        return (index % 2 == 0 ? contentLeftMargin : contentLeftMargin + indention)
    }
    
    private func maxWidthForRendererAtIndex(_ index : Int) -> CGFloat {
        return maxWidth - leftMarginForRendererAtIndex(index) - contentRightMargin
    }
    
    private func estimatedSizeForComment(_ comment : CommentModel, maxWidth : CGFloat) -> CGSize {
        var rendererSize = cacheController.getCommentMeasurement(comment.commentId)
        if rendererSize == nil {
            rendererSize = CommentRenderer.estimatedSize(comment, width: maxWidth)
            cacheController.setCommentMeasurement(rendererSize!, commentId: comment.commentId)
        }

        return rendererSize!
    }
    
    // MARK: - Events
    
    @objc fileprivate func photoCommentsDidChange(_ notification : Notification) {
        let updatedPhotoId = notification.userInfo![StorageServiceEvents.photoId] as! String
        guard photo != nil else { return }
        guard photo!.photoId == updatedPhotoId else { return }
        
        // Get a copy of the updated comments
        self.commentCollection = StorageService.sharedInstance.getComments(photo!.photoId)
        
        // Trigger an animated layout validation
        invalidateMeasurements()
    }
}
