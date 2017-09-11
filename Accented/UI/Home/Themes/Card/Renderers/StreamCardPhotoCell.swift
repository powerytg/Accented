//
//  StreamCardPhotoCell.swift
//  Accented
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class StreamCardPhotoCell: StreamPhotoCellBaseCollectionViewCell {
    private var titleLabel = UILabel()
    private var descLabel = UILabel()
    private var subtitleLabel = UILabel()
    private var footerView = UIImageView(image: UIImage(named: "DarkJournalFooter"))
    private var cardBackgroundLayer = CALayer()

    private var currentTheme : AppTheme {
        return ThemeManager.sharedInstance.currentTheme
    }

    override func initialize() {
        // Background (only available in light card theme)
        contentView.layer.insertSublayer(cardBackgroundLayer, at: 0)
        cardBackgroundLayer.shadowColor = UIColor.black.cgColor
        cardBackgroundLayer.shadowOpacity = 0.2
        cardBackgroundLayer.cornerRadius = 12
        cardBackgroundLayer.shadowRadius = 34
        
        // Title
        titleLabel.textColor = currentTheme.titleTextColor
        titleLabel.font = StreamCardLayoutSpec.titleFont
        titleLabel.numberOfLines = StreamCardLayoutSpec.titleLabelLineCount
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.textColor = UIColor(red: 147 / 255.0, green: 147 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        subtitleLabel.font = StreamCardLayoutSpec.subtitleFont
        subtitleLabel.numberOfLines = StreamCardLayoutSpec.subtitleLineCount
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(subtitleLabel)
        
        // Photo
        renderer.clipsToBounds = true
        renderer.contentMode = .scaleAspectFill
        contentView.addSubview(renderer)
        
        // Descriptions
        descLabel.textColor = currentTheme.standardTextColor
        descLabel.font = ThemeManager.sharedInstance.currentTheme.descFont
        descLabel.numberOfLines = StreamCardLayoutSpec.descLineCount
        descLabel.textAlignment = .center
        descLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(descLabel)
        
        // Bottom line and footer
        footerView.sizeToFit()
        contentView.addSubview(footerView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if photo == nil {
            return
        }
        
        let photoModel = photo!
        let w = self.contentView.bounds.width
        
        var nextY : CGFloat = StreamCardLayoutSpec.topPadding
        
        // Background
        if currentTheme is LightCardTheme {
            cardBackgroundLayer.isHidden = false
            cardBackgroundLayer.frame = contentView.bounds
        } else {
            cardBackgroundLayer.isHidden = true
        }
        
        // Title label
        titleLabel.textColor = currentTheme.titleTextColor
        titleLabel.text = photoModel.title
        layoutLabel(titleLabel, width: w, originY: nextY, padding: StreamCardLayoutSpec.titleHPadding)
        nextY += titleLabel.frame.height + StreamCardLayoutSpec.titleVPadding
        
        // Subtitle label
        subtitleLabel.text = photoModel.user.firstName
        layoutLabel(subtitleLabel, width: w, originY: nextY, padding: StreamCardLayoutSpec.subtitleHPadding)
        nextY += subtitleLabel.frame.height + StreamCardLayoutSpec.photoVPadding
        
        // Photo
        let aspectRatio = photoModel.width / photoModel.height
        let desiredHeight = w / aspectRatio
        var f = renderer.frame
        f.origin.x = StreamCardLayoutSpec.photoLeftPadding
        f.origin.y = nextY
        f.size.width = w - StreamCardLayoutSpec.photoLeftPadding - StreamCardLayoutSpec.photoRightPadding
        f.size.height = min(desiredHeight, StreamCardLayoutSpec.maxPhotoHeight)
        renderer.frame = f
        renderer.photo = photoModel
        nextY += f.height + StreamCardLayoutSpec.photoVPadding
        
        // Description
        descLabel.textColor = currentTheme.standardTextColor
        if let descData = photoModel.desc?.data(using: String.Encoding.utf8) {
            do {
                let descText = try NSAttributedString(data: descData, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
                descLabel.text = descText.string
            } catch _ {
                descLabel.text = nil
            }
        } else {
            descLabel.text = nil
        }
        
        layoutLabel(descLabel, width: w, originY: nextY, padding: StreamCardLayoutSpec.descHPadding)
        
        nextY += descLabel.frame.height + StreamCardLayoutSpec.bottomPadding / 2
        
        f = footerView.frame
        f.origin.x = w / 2 - f.width / 2
        f.origin.y = nextY
        footerView.frame = f
    }
    
    private func layoutLabel(_ label : UILabel, width : CGFloat, originY : CGFloat, padding : CGFloat) {
        var f = label.frame
        f.origin.y = originY
        f.size.width = width - padding * 2
        label.frame = f
        label.sizeToFit()
        
        f = label.frame
        f.origin.x = width / 2 - f.width / 2
        label.frame = f
    }
}
