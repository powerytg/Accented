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

    private var contentRightMargin : CGFloat = 50
    private let contentLeftMargin : CGFloat = 15
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
    private var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    // Cached section height
    private var calculatedSectionHeight : CGFloat = 0
    
    // Fixed content height when there're no comments in the photo
    private var noCommentsSectionHeight : CGFloat = 40
    
    // Maximum number of comments pre-created
    private let maxNumberOfCommentsOnScreen = 3
    
    // Comment renderers
    private var commentRenderers = [CommentRenderer]()
    
    override func initialize() {
        super.initialize()
        
        // Status label
        contentView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - contentRightMargin
        statusLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        statusLabel.font = textFont
        statusLabel.hidden = true
        
        // Loading spinner
        contentView.addSubview(loadingSpinner)
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.hidden = true
        
        // Create a limited number of comment renderers ahead of time
        for _ in 1...maxNumberOfCommentsOnScreen {
            let renderer = CommentRenderer(frame: CGRectZero)
            contentView.addSubview(renderer)
            commentRenderers.append(renderer)
            renderer.hidden = true
        }
        
        // Constraints
        statusLabel.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: contentLeftMargin).active = true
        statusLabel.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: contentTopMargin).active = true
        
        loadingSpinner.leadingAnchor.constraintEqualToAnchor(statusLabel.trailingAnchor, constant: 15).active = true
        loadingSpinner.centerYAnchor.constraintEqualToAnchor(statusLabel.centerYAnchor).active = true
        
        // Events
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(photoCommentsDidChange(_:)), name: StorageServiceEvents.photoCommentsDidUpdate, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func photoModelDidChange() {
        // Stop loading spinner
        loadingSpinner.stopAnimating()
        
        // Refresh the photo comments in background
        guard photo != nil else { return }
        APIService.sharedInstance.refreshCommentsIfNecessary(photo!.photoId)
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }
     
        if photo!.commentsCount == 0 {
            // Photo has no comments
            statusLabel.text = noCommentsText
            statusLabel.hidden = false
            loadingSpinner.hidden = true
        } else if photo!.comments.count == 0{
            // Photo has comments, but have yet loaded
            statusLabel.text = loadingText
            statusLabel.hidden = false
            loadingSpinner.hidden = false
            loadingSpinner.startAnimating()
        } else {
            // Showing the top comments
            statusLabel.hidden = true
            loadingSpinner.hidden = true
            
            var nextY : CGFloat = 0
            for (index, renderer) in commentRenderers.enumerate() {
                if index < photo!.comments.count {
                    let comment = photo!.comments[index]
                    let rendererHeight = renderer.estimatedHeight(comment, width: maxWidth)
                    renderer.frame = CGRectMake(0, nextY, maxWidth, rendererHeight)
                    renderer.comment = photo!.comments[index]
                    renderer.hidden = false
                    
                    nextY += rendererHeight
                } else {
                    renderer.hidden = true
                }
            }
        }
    }
    
    override func calculatedHeightForPhoto(photo: PhotoModel, width: CGFloat) -> CGFloat {
        if photo.commentsCount == 0 || photo.comments.count == 0 {
            return sectionTitleHeight + noCommentsSectionHeight
        } else {
            var calculatedHeight : CGFloat = 0
            let displayCommentsCount = min(photo.comments.count, maxNumberOfCommentsOnScreen)
            for index in 0...(displayCommentsCount - 1) {
                let comment = photo.comments[index]
                let renderer = commentRenderers[index]
                let commentHeight = renderer.estimatedHeight(comment, width: width)
                
                calculatedHeight += commentHeight
            }
            
            return calculatedHeight
        }
    }
    
    // MARK: - Events
    
    @objc private func photoCommentsDidChange(notification : NSNotification) {
        let photoId = notification.userInfo![StorageServiceEvents.photoId] as! String
        guard photo != nil else { return }
        guard photo!.photoId == photoId else { return }
        
        // Trigger an animated layout validation
        invalidateMeasurements()
    }
}
