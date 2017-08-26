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

    private var currentTheme : AppTheme {
        return ThemeManager.sharedInstance.currentTheme
    }

    override func initialize() {
        // Title
        titleLabel.textColor = currentTheme.titleTextColor
        titleLabel.font = SteamCardLayoutSpec.titleFont
        titleLabel.numberOfLines = SteamCardLayoutSpec.titleLabelLineCount
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.textColor = UIColor(red: 147 / 255.0, green: 147 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        subtitleLabel.font = SteamCardLayoutSpec.subtitleFont
        subtitleLabel.numberOfLines = SteamCardLayoutSpec.subtitleLineCount
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
        descLabel.numberOfLines = SteamCardLayoutSpec.descLineCount
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
        
        var nextY : CGFloat = SteamCardLayoutSpec.topPadding
        
        // Title label
        titleLabel.textColor = currentTheme.titleTextColor
        titleLabel.text = photoModel.title
        layoutLabel(titleLabel, width: w, originY: nextY, padding: SteamCardLayoutSpec.titleHPadding)
        nextY += titleLabel.frame.height + SteamCardLayoutSpec.titleVPadding
        
        // Subtitle label
        subtitleLabel.text = photoModel.user.firstName
        layoutLabel(subtitleLabel, width: w, originY: nextY, padding: SteamCardLayoutSpec.subtitleHPadding)
        nextY += subtitleLabel.frame.height + SteamCardLayoutSpec.photoVPadding
        
        // Photo
        let aspectRatio = photoModel.width / photoModel.height
        let desiredHeight = w / aspectRatio
        var f = renderer.frame
        f.origin.y = nextY
        f.size.width = w
        f.size.height = min(desiredHeight, SteamCardLayoutSpec.maxPhotoHeight)
        renderer.frame = f
        renderer.photo = photoModel
        nextY += f.height + SteamCardLayoutSpec.photoVPadding
        
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
        
        layoutLabel(descLabel, width: w, originY: nextY, padding: SteamCardLayoutSpec.descHPadding)
        
        nextY += descLabel.frame.height + SteamCardLayoutSpec.bottomPadding / 2
        
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
