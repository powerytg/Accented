//
//  JournalPhotoCell.swift
//  Accented
//
//  Created by Tiangong You on 5/20/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JournalPhotoCell: UICollectionViewCell {
    
    var photoView = PhotoRenderer()
    var titleLabel = UILabel()
    var descLabel = UILabel()
    var subtitleLabel = UILabel()
    var bottomLine = CALayer()
    var footerView = UIImageView(image: UIImage(named: "DarkJournalFooter"))
    
    var photo : PhotoModel?
    
    fileprivate var currentTheme : JournalTheme? {
        return ThemeManager.sharedInstance.currentTheme as? JournalTheme
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    fileprivate func initialize() {
        // Title
        titleLabel.textColor = currentTheme?.titleTextColor
        titleLabel.font = JournalPhotoLayoutSpec.titleFont
        titleLabel.numberOfLines = JournalPhotoLayoutSpec.titleLabelLineCount
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.textColor = UIColor(red: 147 / 255.0, green: 147 / 255.0, blue: 147 / 255.0, alpha: 1.0)
        subtitleLabel.font = JournalPhotoLayoutSpec.subtitleFont
        subtitleLabel.numberOfLines = JournalPhotoLayoutSpec.subtitleLineCount
        subtitleLabel.textAlignment = .center
        subtitleLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(subtitleLabel)

        // Photo
        photoView.clipsToBounds = true
        photoView.contentMode = .scaleAspectFill
        contentView.addSubview(photoView)
        
        // Descriptions
        descLabel.textColor = currentTheme?.standardTextColor
        descLabel.font = JournalPhotoLayoutSpec.descFont
        descLabel.numberOfLines = JournalPhotoLayoutSpec.descLineCount
        descLabel.textAlignment = .center
        descLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(descLabel)
        
        // Bottom line and footer
        footerView.contentMode = .scaleAspectFit
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
        let w = self.contentView.bounds.width
        
        var nextY : CGFloat = JournalPhotoLayoutSpec.topPadding
        
        // Title label
        titleLabel.textColor = currentTheme?.titleTextColor
        titleLabel.text = photoModel.title
        layoutLabel(titleLabel, width: w, originY: nextY, padding: JournalPhotoLayoutSpec.titleHPadding)
        nextY += titleLabel.frame.height + JournalPhotoLayoutSpec.titleVPadding

        // Subtitle label
        subtitleLabel.text = photoModel.user.firstName
        layoutLabel(subtitleLabel, width: w, originY: nextY, padding: JournalPhotoLayoutSpec.subtitleHPadding)
        nextY += subtitleLabel.frame.height + JournalPhotoLayoutSpec.photoVPadding

        // Photo
        let aspectRatio = photoModel.width / photoModel.height
        let desiredHeight = w / aspectRatio
        var f = photoView.frame
        f.origin.y = nextY
        f.size.width = w
        f.size.height = min(desiredHeight, JournalPhotoLayoutSpec.maxPhotoHeight)
        photoView.frame = f
        photoView.photo = photoModel
        nextY += f.height + JournalPhotoLayoutSpec.photoVPadding
        
        // Description
        descLabel.textColor = currentTheme?.standardTextColor
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
        
        layoutLabel(descLabel, width: w, originY: nextY, padding: JournalPhotoLayoutSpec.descHPadding)
        
        // Display the bottom line if there are descriptions. Otherwise hide the bottom line and show the footer symbol instead
        if descLabel.text?.characters.count > 0 {
            // Make the bottom line further away from the description
            nextY += descLabel.frame.height + JournalPhotoLayoutSpec.bottomPadding
            bottomLine.frame = CGRect(x: 0, y: nextY, width: w, height: 1)
            bottomLine.backgroundColor = currentTheme?.separatorColor.cgColor
            footerView.isHidden = true
            bottomLine.isHidden = false
        } else {
            // Make the footer closer to the photo
            nextY += descLabel.frame.height + JournalPhotoLayoutSpec.bottomPadding / 2
            footerView.isHidden = false
            bottomLine.isHidden = true
            
            f = footerView.frame
            f.size.width = w
            f.size.height = JournalPhotoLayoutSpec.footerHeight
            f.origin.y = nextY
            footerView.frame = f
        }
    }
    
    fileprivate func layoutLabel(_ label : UILabel, width : CGFloat, originY : CGFloat, padding : CGFloat) {
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
