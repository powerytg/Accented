//
//  PhotoCardTemplateGenerator.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PhotoCardTemplateGenerator: StreamTemplateGenerator {
    
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
        titleMeasuringLabel.font = StreamCardLayoutSpec.titleFont
        titleMeasuringLabel.numberOfLines = StreamCardLayoutSpec.titleLabelLineCount
        titleMeasuringLabel.textAlignment = .center
        titleMeasuringLabel.lineBreakMode = .byTruncatingMiddle
        
        // Subtitle
        subtitleMeasuringLabel.font = StreamCardLayoutSpec.subtitleFont
        subtitleMeasuringLabel.numberOfLines = StreamCardLayoutSpec.subtitleLineCount
        subtitleMeasuringLabel.textAlignment = .center
        subtitleMeasuringLabel.lineBreakMode = .byTruncatingMiddle
        
        // Descriptions
        descMeasuringLabel.font = ThemeManager.sharedInstance.currentTheme.descFont
        descMeasuringLabel.numberOfLines = StreamCardLayoutSpec.descLineCount
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
        var nextY : CGFloat = StreamCardLayoutSpec.topPadding
        
        // Measure title
        titleMeasuringLabel.text = photo.title
        titleMeasuringLabel.frame = CGRect(x: 0, y: 0, width: availableWidth - StreamCardLayoutSpec.titleHPadding * 2, height: 0)
        titleMeasuringLabel.sizeToFit()
        nextY += titleMeasuringLabel.bounds.height + StreamCardLayoutSpec.titleVPadding
        
        // Measure subtitle
        subtitleMeasuringLabel.text = photo.user.firstName
        subtitleMeasuringLabel.frame = CGRect(x: 0, y: 0, width: availableWidth - StreamCardLayoutSpec.subtitleHPadding * 2, height: 0)
        subtitleMeasuringLabel.sizeToFit()
        nextY += subtitleMeasuringLabel.bounds.height + StreamCardLayoutSpec.photoVPadding
        
        // Measure photo
        let aspectRatio = photo.width / photo.height
        let desiredHeight = availableWidth / aspectRatio
        let measuredPhotoHeight = min(desiredHeight, StreamCardLayoutSpec.maxPhotoHeight)
        nextY += measuredPhotoHeight + StreamCardLayoutSpec.photoVPadding
        
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
        
        if descText != nil && descText!.characters.count > 0 {
            descMeasuringLabel.text = descText
            descMeasuringLabel.frame = CGRect(x: 0, y: 0, width: availableWidth - StreamCardLayoutSpec.descHPadding * 2, height: 0)
            descMeasuringLabel.sizeToFit()
            nextY += descMeasuringLabel.bounds.height
        }
        
        nextY += StreamCardLayoutSpec.bottomPadding
        
        return nextY
    }
}
