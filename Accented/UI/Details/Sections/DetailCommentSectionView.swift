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
    fileprivate let contentLeftMargin : CGFloat = 15
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
    
    // Maximum number of comments pre-created
    fileprivate let maxNumberOfCommentsOnScreen = 3
    
    // Comment renderers
    fileprivate var commentRenderers = [CommentRenderer]()
    
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
        for _ in 1...maxNumberOfCommentsOnScreen {
            let renderer = CommentRenderer(frame: CGRect.zero)
            contentView.addSubview(renderer)
            commentRenderers.append(renderer)
            renderer.isHidden = true
        }
        
        // Constraints
        statusLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: contentLeftMargin).isActive = true
        statusLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentTopMargin).isActive = true
        
        loadingSpinner.leadingAnchor.constraint(equalTo: statusLabel.trailingAnchor, constant: 15).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor).isActive = true
        
        // Events
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
        APIService.sharedInstance.refreshCommentsIfNecessary(photo!.photoId)
        
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }
     
        if photo!.commentsCount == 0 {
            // Photo has no comments
            statusLabel.text = noCommentsText
            statusLabel.isHidden = false
            loadingSpinner.isHidden = true
        } else if photo!.comments.count == 0{
            // Photo has comments, but have yet loaded
            statusLabel.text = loadingText
            statusLabel.isHidden = false
            loadingSpinner.isHidden = false
            loadingSpinner.startAnimating()
        } else {
            // Showing the top comments
            statusLabel.isHidden = true
            loadingSpinner.isHidden = true
            
            var nextY : CGFloat = 0
            for (index, renderer) in commentRenderers.enumerated() {
                if index < photo!.comments.count {
                    let comment = photo!.comments[index]
                    let rendererHeight = renderer.estimatedHeight(comment, width: maxWidth)
                    renderer.frame = CGRect(x: 0, y: nextY, width: maxWidth, height: rendererHeight)
                    renderer.comment = photo!.comments[index]
                    renderer.isHidden = false
                    
                    nextY += rendererHeight
                } else {
                    renderer.isHidden = true
                }
            }
        }
    }
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
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
    
    @objc fileprivate func photoCommentsDidChange(_ notification : Notification) {
        let photoId = (notification as NSNotification).userInfo![StorageServiceEvents.photoId] as! String
        guard photo != nil else { return }
        guard photo!.photoId == photoId else { return }
        
        // Trigger an animated layout validation
        invalidateMeasurements()
    }
}
