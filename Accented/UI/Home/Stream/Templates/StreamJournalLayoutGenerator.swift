//
//  StreamJournalLayoutGenerator.swift
//  Accented
//
//  Created by Tiangong You on 5/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

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
        titleMeasuringLabel.textAlignment = .Center
        titleMeasuringLabel.lineBreakMode = .ByTruncatingMiddle
        
        // Subtitle
        subtitleMeasuringLabel.font = JournalPhotoLayoutSpec.subtitleFont
        subtitleMeasuringLabel.numberOfLines = JournalPhotoLayoutSpec.subtitleLineCount
        subtitleMeasuringLabel.textAlignment = .Center
        subtitleMeasuringLabel.lineBreakMode = .ByTruncatingMiddle
        
        // Descriptions
        descMeasuringLabel.font = JournalPhotoLayoutSpec.descFont
        descMeasuringLabel.numberOfLines = JournalPhotoLayoutSpec.descLineCount
        descMeasuringLabel.textAlignment = .Center
        descMeasuringLabel.lineBreakMode = .ByTruncatingTail
    }
    
    override func generateLayoutMetadata(photos : [PhotoModel]) -> [StreamLayoutTemplate]{
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

    private func estimatedHeightForPhoto(photo : PhotoModel) -> CGFloat {
        var nextY : CGFloat = JournalPhotoLayoutSpec.topPadding
        
        // Measure title
        titleMeasuringLabel.text = photo.title
        titleMeasuringLabel.frame = CGRectMake(0, 0, availableWidth - JournalPhotoLayoutSpec.titleHPadding * 2, 0)
        titleMeasuringLabel.sizeToFit()
        nextY += CGRectGetHeight(titleMeasuringLabel.bounds) + JournalPhotoLayoutSpec.titleVPadding
        
        // Measure subtitle
        subtitleMeasuringLabel.text = photo.firstName
        subtitleMeasuringLabel.frame = CGRectMake(0, 0, availableWidth - JournalPhotoLayoutSpec.subtitleHPadding * 2, 0)
        subtitleMeasuringLabel.sizeToFit()
        nextY += CGRectGetHeight(subtitleMeasuringLabel.bounds) + JournalPhotoLayoutSpec.photoVPadding
        
        // Measure photo
        let aspectRatio = photo.width / photo.height
        let desiredHeight = availableWidth / aspectRatio
        let measuredPhotoHeight = min(desiredHeight, JournalPhotoLayoutSpec.maxPhotoHeight)
        nextY += measuredPhotoHeight + JournalPhotoLayoutSpec.photoVPadding
        
        // Measure description
        var descText : String?
        if let descData = photo.desc?.dataUsingEncoding(NSUTF8StringEncoding) {
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
            descMeasuringLabel.frame = CGRectMake(0, 0, availableWidth - JournalPhotoLayoutSpec.descHPadding * 2, 0)
            descMeasuringLabel.sizeToFit()
            nextY += CGRectGetHeight(descMeasuringLabel.bounds)
        }
        
        nextY += JournalPhotoLayoutSpec.bottomPadding
        
        return nextY
    }
    

}
