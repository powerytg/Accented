//
//  DetailDescriptionSectionView.swift
//  Accented
//
//  Essential info section in detail page, consists the photo title, description and timestamp
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class DetailDescriptionSectionView: DetailSectionViewBase {
    
    fileprivate var titleLabel = UILabel()
    fileprivate var dateLabel = UILabel()
    fileprivate var descLabel = TTTAttributedLabel(frame: CGRect.zero)
    
    fileprivate let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 34)
    fileprivate let dateFont = UIFont(name: "HelveticaNeue", size: 14)
    fileprivate let descFont = ThemeManager.sharedInstance.currentTheme.descFont
    fileprivate let descColor = ThemeManager.sharedInstance.currentTheme.descTextColor
    fileprivate let linkColor = ThemeManager.sharedInstance.currentTheme.linkColor
    fileprivate let linkPressColor = ThemeManager.sharedInstance.currentTheme.linkHighlightColor
    
    fileprivate let titleTopPadding : CGFloat = 12
    fileprivate let titleRightPadding : CGFloat = 70
    fileprivate let dateRightPadding : CGFloat = 120
    fileprivate let descRightPadding : CGFloat = 30
    fileprivate let gap : CGFloat = 10

    fileprivate var formattedDescText : NSAttributedString?
    fileprivate var descSize : CGSize?
    
    override func initialize() {
        super.initialize()
        
        // Title label
        titleLabel.font = titleFont
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)

        // Date label
        dateLabel.font = dateFont
        dateLabel.textColor = UIColor.white
        contentView.addSubview(dateLabel)
        
        // Desc label
        descLabel.font = descFont
        descLabel.textColor = ThemeManager.sharedInstance.currentTheme.descTextColor
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.linkAttributes = [NSForegroundColorAttributeName : linkColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        descLabel.activeLinkAttributes = [NSForegroundColorAttributeName : linkPressColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        contentView.addSubview(descLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        
        var nextY : CGFloat = contentTopPadding
        
        // Title
        titleLabel.text = photo.title
        var f = titleLabel.frame
        f.origin.x = contentLeftPadding
        f.origin.y = nextY
        f.size.width = width - contentLeftPadding - titleRightPadding
        titleLabel.frame = f
        titleLabel.text = photo.title
        titleLabel.sizeToFit()
        nextY += titleLabel.frame.size.height
        
        // Creation date
        if let dateString = displayDateString(photo) {
            nextY += gap
            dateLabel.isHidden = false
            f = dateLabel.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = width - contentLeftPadding - dateRightPadding
            dateLabel.frame = f
            dateLabel.text = dateString
            dateLabel.sizeToFit()
            nextY += dateLabel.frame.size.height
        } else{
            dateLabel.isHidden = true
        }
        
        // Descriptions
        if formattedDescText != nil && descSize != nil {
            nextY += gap
            dateLabel.isHidden = false
            descLabel.setText(formattedDescText)
            f = descLabel.frame
            f.origin.x = contentLeftPadding
            f.origin.y = nextY
            f.size.width = descSize!.width
            f.size.height = descSize!.height
            descLabel.frame = f
        } else {
            descLabel.isHidden = true
        }
    }
    
    // MARK: - Measurments
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        var measuredHeight : CGFloat = contentTopPadding
        
        // Title
        let maxTitleWidth = width - contentLeftPadding - titleRightPadding
        let titleHeight = NSString(string : photo.title).boundingRect(with: CGSize(width: maxTitleWidth,
                                                                                   height: CGFloat.greatestFiniteMagnitude),
                                                                      options: .usesLineFragmentOrigin,
                                                                      attributes: [NSFontAttributeName: titleFont!],
                                                                      context: nil).size.height
        measuredHeight += titleHeight
        
        // Date
        if let date = displayDateString(photo) {
            let maxDateWidth = width - contentLeftPadding - dateRightPadding
            let dateHeight = NSString(string : date).boundingRect(with: CGSize(width: maxDateWidth, height: CGFloat.greatestFiniteMagnitude),
                                                              options: .usesLineFragmentOrigin,
                                                              attributes: [NSFontAttributeName: dateFont!],
                                                              context: nil).size.height
            measuredHeight += dateHeight + gap
        }
        
        // Descriptions
        if photo.desc != nil {
            let maxDescWidth = width - contentLeftPadding - descRightPadding
            formattedDescText = formattedDescriptionString(photo)
            if formattedDescText != nil {
                descSize = formattedDescText!.boundingRect(with: CGSize(width: maxDescWidth, height: CGFloat.greatestFiniteMagnitude),
                                                         options: .usesLineFragmentOrigin,
                                                         context: nil).size
                measuredHeight += descSize!.height
            }
        }
        
        return measuredHeight
    }
    
    // MARK: - Private
    
    fileprivate func formattedDescriptionString(_ photo : PhotoModel) -> NSAttributedString? {
        guard let desc = photo.desc else { return nil }
        
        let descStringWithStyles = NSString(format:"<span style=\"color: #989898; font-family: \(descFont.fontName); font-size: \(descFont.pointSize)\">%@</span>" as NSString, desc) as String
        guard let data = descStringWithStyles.data(using: String.Encoding.utf8) else { return nil }
        
        let options : [String : Any] = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                              NSCharacterEncodingDocumentAttribute:String.Encoding.utf8.rawValue]
        
        var formattedDesc : NSAttributedString?
        do {
            formattedDesc = try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            formattedDesc = nil
        }
        
        return formattedDesc
    }
    
    fileprivate func displayDateString(_ photo : PhotoModel) -> String? {
        if photo.creationDate == nil {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: photo.creationDate! as Date)
    }
    
    override func entranceAnimationWillBegin() {
        titleLabel.alpha = 0
        dateLabel.alpha = 0
        descLabel.alpha = 0
        
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        dateLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        descLabel.transform = CGAffineTransform(translationX: 0, y: 30)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1, animations: { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.transform = CGAffineTransform.identity
        })
        
        UIView .addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: { [weak self] in
            self?.dateLabel.alpha = 1
            self?.dateLabel.transform = CGAffineTransform.identity
        })
        
        UIView .addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 1, animations: { [weak self] in
            self?.descLabel.alpha = 1
            self?.descLabel.transform = CGAffineTransform.identity
        })
    }
}
