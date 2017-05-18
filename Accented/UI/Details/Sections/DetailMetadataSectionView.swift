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

    fileprivate var contentRightMargin : CGFloat = 50
    fileprivate let contentLeftMargin : CGFloat = 15
    fileprivate var contentTopMargin : CGFloat = 0
    fileprivate var contentBottomMargin : CGFloat = 20
    fileprivate let noEXIFText = "This photo does not have camera info"
    fileprivate let textFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
    override var title: String? {
        return "EQUIPMENTS"
    }

    fileprivate var exifLabel = UILabel()
    
    override func initialize() {
        super.initialize()
        
        contentView.addSubview(exifLabel)
        exifLabel.translatesAutoresizingMaskIntoConstraints = false
        exifLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - contentRightMargin
        exifLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        exifLabel.font = textFont
        exifLabel.numberOfLines = 0
        exifLabel.lineBreakMode = .byWordWrapping
        
        // Constraints
        exifLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: contentLeftMargin).isActive = true
        exifLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: contentTopMargin).isActive = true
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
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        let maxTextWidth = maxWidth - contentLeftMargin - contentRightMargin
        let displayText = getDisplayEXIFText()
        let textHeight = NSString(string : displayText).boundingRect(with: CGSize(width: maxTextWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                             options: .usesLineFragmentOrigin,
                                                                             attributes: [NSFontAttributeName: textFont!],
                                                                             context: nil).size.height
        return textHeight + sectionTitleHeight + contentBottomMargin
    }
    
    // MARK: - Private
    
    fileprivate func getDisplayEXIFText() -> String {
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
    
    fileprivate func displayApertureString() -> String? {
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
