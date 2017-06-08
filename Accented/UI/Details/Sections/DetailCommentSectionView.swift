//
//  DetailCommentSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentSectionView: DetailSectionViewBase {

    private var contentRightMargin : CGFloat = 50
    private let contentLeftMargin : CGFloat = 24
    private var contentTopMargin : CGFloat = 0
    private var contentBottomMargin : CGFloat = 15
    
    private let noCommentsText = "This photo does not have comments"
    private let loadingText = "Loading comments..."
    private let errorText = "Could not retrieve comments"
    
    private let textFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
    override var title: String? {
        return "COMMENTS"
    }
    
    // Status label will be visible if there are no comments, or if the comments are being loaded
    private var statusLabel = UILabel()
    private var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    // Cached section height
    private var calculatedSectionHeight : CGFloat = 0
    
    // Fixed content height when there're no comments in the photo
    private var noCommentsSectionHeight : CGFloat = 40
    
    // Comment renderer vertical padding
    private var vPadding : CGFloat = 10
    
    // Comment renderer indention
    private var indention : CGFloat = 12
    
    // Load-more button top margin
    private var loadMoreMarginTop : CGFloat = 10
    
    // Maximum number of comments pre-created
    private let maxNumberOfCommentsOnScreen = 4
    
    // Comment renderers
    private var commentRenderers = [CommentRenderer]()
    
    // Load more button
    private let loadMoreButton = UIButton(type: UIButtonType.custom)
    
    // Comment collection
    private var commentCollection : CommentCollectionModel!
    
    override func initialize() {
        super.initialize()
        
        // Status label
        contentView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - contentLeftMargin - contentRightMargin
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
        
        // Refresht the comment list in background
        APIService.sharedInstance.getComments(photo.photoId)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func navigateToCommentsPage(_ sender : NSObject) {
        NavigationService.sharedInstance.navigateToCommentsPage(photo)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard commentCollection != nil else { return }
        
        if commentCollection.totalCount == 0 {
            // Photo has no comments
            statusLabel.text = noCommentsText
            statusLabel.isHidden = false
            loadingSpinner.stopAnimating()
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
            loadingSpinner.stopAnimating()
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
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
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
            calculatedHeight += loadMoreButton.frame.size.height + loadMoreMarginTop + contentBottomMargin
            return calculatedHeight + sectionTitleHeight
        }
    }
    
    private func leftMarginForRendererAtIndex(_ index : Int) -> CGFloat {
        return (index % 2 == 0 ? contentLeftMargin : contentLeftMargin + indention)
    }
    
    private func maxWidthForRendererAtIndex(_ index : Int) -> CGFloat {
        return width - leftMarginForRendererAtIndex(index) - contentRightMargin
    }
    
    private func estimatedSizeForComment(_ comment : CommentModel, maxWidth : CGFloat) -> CGSize {
        return CommentRenderer.estimatedSize(comment, width: maxWidth)
    }
    
    // MARK: - Events
    
    @objc private func photoCommentsDidChange(_ notification : Notification) {
        let updatedPhotoId = notification.userInfo![StorageServiceEvents.photoId] as! String
        guard photo.photoId == updatedPhotoId else { return }
        
        // Get a copy of the updated comments
        self.commentCollection = StorageService.sharedInstance.getComments(photo.photoId)
        
        // Trigger an animated layout validation
        invalidateSize()
    }
}
