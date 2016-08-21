//
//  DetailCommentSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailCommentSectionView: DetailSectionViewBase {
/*
    override var sectionId: String {
        return "comments"
    }

    private var contentRightMargin : CGFloat = 50
    private let contentLeftMargin : CGFloat = 15
    private var contentTopMargin : CGFloat = 0
    private var contentBottomMargin : CGFloat = 15
    
    private let noCommentsText = "This photo does not have comments"
    private let loadingText = "Loading comments..."
    
    private let textFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
    override var title: String? {
        return "COMMENTS"
    }
    
    // Status label will be visible if there are no comments, or if the comments are being loaded
    private var statusLabel = UILabel()
    private var loadingSpinner = UIProgressView(progressViewStyle: .Default)
    
    // Cached section height
    private var calculatedSectionHeight : CGFloat = 0
    
    // Fixed content height when there're no comments in the photo
    private var noCommentsSectionHeight : CGFloat = 40

    // Comment renderers
    private let commentRendererCountForDisplay = 3
    private var commentRenderers = [CommentRenderer]()
    
    override func initialize() {
        super.initialize()
        
        // Status label
        contentView.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - contentRightMargin
        statusLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        statusLabel.font = textFont
        statusLabel.numberOfLines = 1
        statusLabel.hidden = false
        
        // Create a limited number of comment renderers ahead of time
        for _ in 1...commentRendererCountForDisplay {
            let renderer = CommentRenderer(frame: CGRectZero)
            contentView.addSubview(renderer)
            contentView.hidden = true
        }
        
        // Constraints
        statusLabel.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: contentLeftMargin).active = true
        statusLabel.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: contentTopMargin).active = true
    }
    
    override func photoModelDidChange() {
        super.photoModelDidChange()
        guard photo != nil else { return }
        
        var contentHeight : CGFloat = 0
        if photo!.commentsCount == 0 {
            // Photo has no comments
            statusLabel.text = noCommentsText
            statusLabel.hidden = false
            contentHeight = noCommentsSectionHeight
        } else if photo!.comments.count == 0{
            // Photo has comments, but have yet loaded
            statusLabel.text = loadingText
            statusLabel.hidden = false
            contentHeight = noCommentsSectionHeight
        } else {
            statusLabel.hidden = true
        }
        
        calculatedSectionHeight = contentHeight + sectionTitleHeight + contentBottomMargin
    }
    
    override func estimatedHeight(width: CGFloat) -> CGFloat {
        return calculatedSectionHeight
    }
    
    // MARK : - Private
    private func getDisplayEXIFText() -> String {
        guard photo != nil else { return noEXIFText }
        
        let aperture = displayApertureString()
        if aperture == nil && photo!.camera == nil && photo?.lens == nil {
            return noEXIFText
        } else {
            // If only aperture was available, display the aperture
            if photo!.camera == nil && photo?.lens == nil {
                return "Aperture was \(aperture!)"
            }
            
            // If only lens was available, display the lens
            if photo!.camera == nil && aperture == nil {
                return "Lens used in this photo was \(photo!.lens!)"
            }
            
            var displayText = ""
            if photo!.camera != nil {
                displayText = "This photo was taken with \(photo!.camera!)"
            }
            
            if photo!.lens != nil {
                displayText += " and \(photo!.lens!)"
            }
            
            if aperture != nil {
                displayText += ", aperture was \(aperture!)"
            }
            
            return displayText
        }
    }
    
    private func displayApertureString() -> String? {
        if let aperture = photo?.aperture {
            if aperture.hasPrefix("f") {
                return aperture
            } else {
                return "f/\(aperture)"
            }
        } else {
            return nil
        }
    }

*/
}
