//
//  DetailMetadataSectionView.swift
//  Accented
//
//  Info section in the detail page, showing photo scores and shooting conditions
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailMetadataSectionView: DetailSectionViewBase {

    fileprivate var contentRightMargin : CGFloat = 50
    fileprivate var contentTopMargin : CGFloat = 0
    fileprivate var contentBottomMargin : CGFloat = 20
    fileprivate let textFont = ThemeManager.sharedInstance.currentTheme.descFont
    
    override var title: String? {
        return "ABOUT"
    }

    fileprivate var exifLabel = UILabel()
    
    override func initialize() {
        super.initialize()
        
        contentView.addSubview(exifLabel)
        exifLabel.textColor = ThemeManager.sharedInstance.currentTheme.descTextColor
        exifLabel.font = textFont
        exifLabel.numberOfLines = 0
        exifLabel.lineBreakMode = .byWordWrapping
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let displayText = getInfoText()
        var f = exifLabel.frame
        f.size.width = width - contentLeftPadding - contentRightMargin
        f.origin.x = contentLeftPadding
        f.origin.y = contentTopMargin
        exifLabel.frame = f
        exifLabel.text = displayText
        exifLabel.sizeToFit()
    }
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        let maxTextWidth = maxWidth - contentLeftPadding - contentRightMargin
        let displayText = getInfoText()
        if displayText == nil {
            return 0
        }
        let textHeight = NSString(string : displayText!).boundingRect(with: CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                     options: .usesLineFragmentOrigin,
                                                                     attributes: [NSFontAttributeName: textFont],
                                                                     context: nil).size.height
        return textHeight + sectionTitleHeight + contentBottomMargin
    }
    
    // MARK: - Private
    
    fileprivate func getInfoText() -> String? {
        let aperture = displayApertureString()
        if aperture == nil && photo.camera == nil && photo.lens == nil {
            return nil
        } else {
            // If only aperture was available, display the aperture
            if photo.camera == nil && photo.lens == nil {
                return "Aperture was \(aperture!)"
            }

            // If only lens was available, display the lens
            if photo.camera == nil && aperture == nil {
                return "Lens used in this photo was \(photo.lens!)"
            }

            var displayText = ""
            if photo.camera != nil {
                displayText = "This photo was taken with \(photo.camera!)"
            }
            
            if photo.lens != nil {
                displayText += " and \(photo.lens!)"
            }
            
            if aperture != nil {
                displayText += ", aperture was \(aperture!)"
            }
            
            return displayText
        }
    }
    
    fileprivate func displayApertureString() -> String? {
        if let aperture = photo.aperture {
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
