//
//  DetailMetadataSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailMetadataSectionView: DetailSectionViewBase {

    override var sectionId: String {
        return "metadata"
    }

    private var contentRightMargin : CGFloat = 50
    private let contentLeftMargin : CGFloat = 15
    private var contentTopMargin : CGFloat = 0
    private var contentBottomMargin : CGFloat = 15
    private let noEXIFText = "This photo does not have camera info"
    private let textFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
    override var title: String? {
        return "EQUIPMENTS"
    }

    private var exifLabel = UILabel()
    
    override func initialize() {
        super.initialize()
        
        contentView.addSubview(exifLabel)
        exifLabel.translatesAutoresizingMaskIntoConstraints = false
        exifLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - contentRightMargin
        exifLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        exifLabel.font = textFont
        exifLabel.numberOfLines = 0
        exifLabel.lineBreakMode = .ByWordWrapping
        
        // Constraints
        exifLabel.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: contentLeftMargin).active = true
        exifLabel.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: contentTopMargin).active = true
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }
        
        let displayText = getDisplayEXIFText()
        exifLabel.text = displayText
    }
    
    override func calculatedHeightForPhoto(photo: PhotoModel, width: CGFloat) -> CGFloat {
        let maxTextWidth = maxWidth - contentLeftMargin - contentRightMargin
        let displayText = getDisplayEXIFText()
        let textHeight = NSString(string : displayText).boundingRectWithSize(CGSizeMake(maxTextWidth, CGFloat.max),
                                                                             options: .UsesLineFragmentOrigin,
                                                                             attributes: [NSFontAttributeName: textFont!],
                                                                             context: nil).size.height
        return textHeight + sectionTitleHeight + contentBottomMargin
    }
    
    // MARK: - Private
    
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
