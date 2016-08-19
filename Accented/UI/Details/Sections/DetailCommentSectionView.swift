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
    private let contentLeftMargin : CGFloat = 15
    private var contentTopMargin : CGFloat = 0
    private var contentBottomMargin : CGFloat = 15
    private let commentsText = "This photo does not have comments"
    private let textFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
    override var title: String? {
        return "COMMENTS"
    }
    
    private var noCommentsLabel = UILabel()
    private var loadingSpinner = UIProgressView(progressViewStyle: .Default)
    private var calculatedSectionHeight : CGFloat = 0
    
    override func initialize() {
        super.initialize()
        
        contentView.addSubview(noCommentsLabel)
        
        noCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
        noCommentsLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - contentRightMargin
        noCommentsLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        noCommentsLabel.font = textFont
        noCommentsLabel.numberOfLines = 0
        noCommentsLabel.lineBreakMode = .ByWordWrapping
        
        // Constraints
        noCommentsLabel.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: contentLeftMargin).active = true
        noCommentsLabel.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: contentTopMargin).active = true
    }
    
    override func photoModelDidChange() {
        super.photoModelDidChange()
        
        let displayText = getDisplayEXIFText()
        exifLabel.text = displayText
        
        // Update measurements
        let maxTextWidth = maxWidth - contentLeftMargin - contentRightMargin
        let textHeight = NSString(string : displayText).boundingRectWithSize(CGSizeMake(maxTextWidth, CGFloat.max),
                                                                             options: .UsesLineFragmentOrigin,
                                                                             attributes: [NSFontAttributeName: textFont!],
                                                                             context: nil).size.height
        calculatedSectionHeight = textHeight + sectionTitleHeight + contentBottomMargin
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


}
