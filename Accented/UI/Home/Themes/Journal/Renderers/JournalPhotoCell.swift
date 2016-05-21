//
//  JournalPhotoCell.swift
//  Accented
//
//  Created by Tiangong You on 5/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalPhotoCell: UICollectionViewCell {
    
    var photoView = PhotoRenderer()
    var titleLabel = UILabel()
    var descLabel = UILabel()
    var subtitleLabel = UILabel()
    var bottomLine = CALayer()
    var footerView = UIImageView(image: UIImage(named: "DarkJournalFooter"))
    
    var photo : PhotoModel?
    
    private var lineColor : UIColor {
        let journalTheme = ThemeManager.sharedInstance.currentTheme as! JournalTheme
        return journalTheme.separatorColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        // Title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = JournalPhotoLayoutSpec.titleFont
        titleLabel.numberOfLines = JournalPhotoLayoutSpec.titleLabelLineCount
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByTruncatingMiddle
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.textColor = UIColor(red: 147 / 255.0, green: 147 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        subtitleLabel.font = JournalPhotoLayoutSpec.subtitleFont
        subtitleLabel.numberOfLines = JournalPhotoLayoutSpec.subtitleLineCount
        subtitleLabel.textAlignment = .Center
        subtitleLabel.lineBreakMode = .ByTruncatingMiddle
        contentView.addSubview(subtitleLabel)

        // Photo
        photoView.clipsToBounds = true
        photoView.contentMode = .ScaleAspectFill
        contentView.addSubview(photoView)
        
        // Descriptions
        descLabel.textColor = UIColor(red: 147 / 255.0, green: 147 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        descLabel.font = JournalPhotoLayoutSpec.descFont
        descLabel.numberOfLines = JournalPhotoLayoutSpec.descLineCount
        descLabel.textAlignment = .Center
        descLabel.lineBreakMode = .ByTruncatingTail
        contentView.addSubview(descLabel)
        
        // Bottom line and footer
        footerView.contentMode = .ScaleAspectFit
        contentView.addSubview(footerView)
        self.layer.addSublayer(bottomLine)
    }
    
    override func prepareForReuse() {
        photoView.photo = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if photo == nil {
            return
        }
        
        let photoModel = photo!
        let w = CGRectGetWidth(self.contentView.bounds)
        
        var nextY : CGFloat = JournalPhotoLayoutSpec.topPadding
        
        // Title label
        titleLabel.text = photoModel.title
        layoutLabel(titleLabel, width: w, originY: nextY, padding: JournalPhotoLayoutSpec.titleHPadding)
        nextY += CGRectGetHeight(titleLabel.frame) + JournalPhotoLayoutSpec.titleVPadding

        // Subtitle label
        subtitleLabel.text = photoModel.firstName
        layoutLabel(subtitleLabel, width: w, originY: nextY, padding: JournalPhotoLayoutSpec.subtitleHPadding)
        nextY += CGRectGetHeight(subtitleLabel.frame) + JournalPhotoLayoutSpec.photoVPadding

        // Photo
        let aspectRatio = photoModel.width / photoModel.height
        let desiredHeight = w / aspectRatio
        var f = photoView.frame
        f.origin.y = nextY
        f.size.width = w
        f.size.height = min(desiredHeight, JournalPhotoLayoutSpec.maxPhotoHeight)
        photoView.frame = f
        photoView.photo = photoModel
        nextY += CGRectGetHeight(f) + JournalPhotoLayoutSpec.photoVPadding
        
        // Description
        if let descData = photoModel.desc?.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let descText = try NSAttributedString(data: descData, options: [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType], documentAttributes: nil)
                descLabel.text = descText.string
            } catch _ {
                descLabel.text = nil
            }
        } else {
            descLabel.text = nil
        }
        
        layoutLabel(descLabel, width: w, originY: nextY, padding: JournalPhotoLayoutSpec.descHPadding)
        
        // Display the bottom line if there are descriptions. Otherwise hide the bottom line and show the footer symbol instead
        if descLabel.text?.characters.count > 0 {
            // Make the bottom line further away from the description
            nextY += CGRectGetHeight(descLabel.frame) + JournalPhotoLayoutSpec.bottomPadding
            bottomLine.frame = CGRectMake(0, nextY, w, 1)
            bottomLine.backgroundColor = lineColor.CGColor
            footerView.hidden = true
            bottomLine.hidden = false
        } else {
            // Make the footer closer to the photo
            nextY += CGRectGetHeight(descLabel.frame) + JournalPhotoLayoutSpec.bottomPadding / 2
            footerView.hidden = false
            bottomLine.hidden = true
            
            f = footerView.frame
            f.size.width = w
            f.size.height = JournalPhotoLayoutSpec.footerHeight
            f.origin.y = nextY
            footerView.frame = f
        }
    }
    
    private func layoutLabel(label : UILabel, width : CGFloat, originY : CGFloat, padding : CGFloat) {
        var f = label.frame
        f.origin.y = originY
        f.size.width = width - padding * 2
        label.frame = f
        label.sizeToFit()

        f = label.frame
        f.origin.x = width / 2 - CGRectGetWidth(f) / 2
        label.frame = f
    }
    
}
