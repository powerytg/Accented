//
//  StreamJournalLayoutGenerator.swift
//  Accented
//
//  Created by Tiangong You on 5/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
private func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class StreamJournalLayoutGenerator: StreamTemplateGenerator {

    // Title measuring label
    private var titleMeasuringLabel = UILabel()
    
    // Subtitle measuring label
    private var subtitleMeasuringLabel = UILabel()
    
    // Description measuring label
    private var descMeasuringLabel = UILabel()

    required init(maxWidth: CGFloat) {
        super.init(maxWidth: maxWidth)
        
        // Initialize labels for measuring
        // Title
        titleMeasuringLabel.font = JournalPhotoLayoutSpec.titleFont
        titleMeasuringLabel.numberOfLines = JournalPhotoLayoutSpec.titleLabelLineCount
        titleMeasuringLabel.textAlignment = .center
        titleMeasuringLabel.lineBreakMode = .byTruncatingMiddle
        
        // Subtitle
        subtitleMeasuringLabel.font = JournalPhotoLayoutSpec.subtitleFont
        subtitleMeasuringLabel.numberOfLines = JournalPhotoLayoutSpec.subtitleLineCount
        subtitleMeasuringLabel.textAlignment = .center
        subtitleMeasuringLabel.lineBreakMode = .byTruncatingMiddle
        
        // Descriptions
        descMeasuringLabel.font = ThemeManager.sharedInstance.currentTheme.descFont
        descMeasuringLabel.numberOfLines = JournalPhotoLayoutSpec.descLineCount
        descMeasuringLabel.textAlignment = .center
        descMeasuringLabel.lineBreakMode = .byTruncatingTail
    }
    
    override func generateLayoutMetadata(_ photos : [PhotoModel]) -> [StreamLayoutTemplate]{
        if photos.count == 0 {
            return []
        }
        
        var templates : [StreamLayoutTemplate] = []
        for photo in photos {
            let calculatedHeight = estimatedHeightForPhoto(photo)
            let template = JournalLayoutTemplate(width: availableWidth, height: calculatedHeight)
            templates.append(template)
        }
        
        return templates
    }

    private func estimatedHeightForPhoto(_ photo : PhotoModel) -> CGFloat {
        var nextY : CGFloat = JournalPhotoLayoutSpec.topPadding
        
        // Measure title
        titleMeasuringLabel.text = photo.title
        titleMeasuringLabel.frame = CGRect(x: 0, y: 0, width: availableWidth - JournalPhotoLayoutSpec.titleHPadding * 2, height: 0)
        titleMeasuringLabel.sizeToFit()
        nextY += titleMeasuringLabel.bounds.height + JournalPhotoLayoutSpec.titleVPadding
        
        // Measure subtitle
        subtitleMeasuringLabel.text = photo.user.firstName
        subtitleMeasuringLabel.frame = CGRect(x: 0, y: 0, width: availableWidth - JournalPhotoLayoutSpec.subtitleHPadding * 2, height: 0)
        subtitleMeasuringLabel.sizeToFit()
        nextY += subtitleMeasuringLabel.bounds.height + JournalPhotoLayoutSpec.photoVPadding
        
        // Measure photo
        let aspectRatio = photo.width / photo.height
        let desiredHeight = availableWidth / aspectRatio
        let measuredPhotoHeight = min(desiredHeight, JournalPhotoLayoutSpec.maxPhotoHeight)
        nextY += measuredPhotoHeight + JournalPhotoLayoutSpec.photoVPadding
        
        // Measure description
        var descText : String?
        if let descData = photo.desc?.data(using: String.Encoding.utf8) {
            do {
                let strippedText = try NSAttributedString(data: descData, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
                descText = strippedText.string
            } catch _ {
                descText = nil
            }
        } else {
            descText = nil
        }

        if descText?.characters.count > 0 {
            descMeasuringLabel.text = descText
            descMeasuringLabel.frame = CGRect(x: 0, y: 0, width: availableWidth - JournalPhotoLayoutSpec.descHPadding * 2, height: 0)
            descMeasuringLabel.sizeToFit()
            nextY += descMeasuringLabel.bounds.height
        }
        
        nextY += JournalPhotoLayoutSpec.bottomPadding
        
        return nextY
    }
    

}
