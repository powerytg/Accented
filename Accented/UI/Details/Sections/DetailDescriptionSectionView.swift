//
//  swift
//  Accented
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class DetailDescriptionSectionView: DetailSectionViewBase {

    override var sectionId: String {
        return "desc"
    }
    
    private var titleLabel = UILabel()
    private var dateLabel = UILabel()
    private var descLabel = TTTAttributedLabel(frame: CGRectZero)
    
    private let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 34)
    private let dateFont = UIFont(name: "HelveticaNeue", size: 14)    
    private let linkColor = UIColor(red: 92 / 255.0, green: 125 / 255.0, blue: 161 / 255.0, alpha: 1)
    private let linkPressColor = UIColor.whiteColor()
    
    private let contentLeftMargin : CGFloat = 15
    private let titleLabelTopMargin : CGFloat = 12
    private let titleLabelRightMargin : CGFloat = 70
    private let dateLabelTopMargin : CGFloat = 10
    private let dateLabelRightMargin : CGFloat = 120
    private let descLabelTopMargin : CGFloat = 10
    private let descLabelRightMargin : CGFloat = 30
    
    // Constraints
    private var descLabelTopConstraint : NSLayoutConstraint?
    
    override func initialize() {
        super.initialize()
        
        // Title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - titleLabelRightMargin
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        contentView.addSubview(titleLabel)

        // Date label
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = dateFont
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - dateLabelRightMargin
        contentView.addSubview(dateLabel)
        
        // Desc label
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = descFont
        descLabel.textColor = descColor
        descLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - descLabelRightMargin
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .ByWordWrapping
        descLabel.linkAttributes = [NSForegroundColorAttributeName : linkColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleNone.rawValue]
        descLabel.activeLinkAttributes = [NSForegroundColorAttributeName : linkPressColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleNone.rawValue]
        contentView.addSubview(descLabel)
        
        // Constaints
        titleLabel.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor, constant: contentLeftMargin).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(self.contentView.topAnchor, constant: titleLabelTopMargin).active = true
        
        dateLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
        dateLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: dateLabelTopMargin).active = true

        descLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        guard photo != nil else { return }
        
        // Title
        titleLabel.text = photo!.title
        
        // Creation date
        if let dateString = displayDateString(photo!) {
            dateLabel.text = dateString
            dateLabel.hidden = false
            
            descLabelTopConstraint?.active = false
            descLabelTopConstraint = descLabel.topAnchor.constraintEqualToAnchor(dateLabel.bottomAnchor, constant: descLabelTopMargin)
            descLabelTopConstraint?.active = true
        } else{
            dateLabel.hidden = true
            
            descLabelTopConstraint?.active = false
            descLabelTopConstraint = descLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: descLabelTopMargin)
            descLabelTopConstraint?.active = true
        }
        
        // Descriptions
        if let formattedDesc = formattedDescriptionString(photo!) {
            descLabel.setText(formattedDesc)
        } else {
            descLabel.text = photo!.desc
        }
    }
    
    // MARK: - Measurments
    
    override func calculatedHeightForPhoto(photo : PhotoModel, width : CGFloat) -> CGFloat {
        // Title
        let maxTitleWidth = width - contentLeftMargin - titleLabelRightMargin
        var titleHeight = NSString(string : photo.title).boundingRectWithSize(CGSizeMake(maxTitleWidth, CGFloat.max),
                                                                            options: .UsesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: titleFont!],
                                                                            context: nil).size.height
        titleHeight += titleLabelTopMargin
        
        // Date
        var dateHeight : CGFloat = 0
        if let date = displayDateString(photo) {
            let maxDateWidth = width - contentLeftMargin - dateLabelRightMargin
            dateHeight = NSString(string : date).boundingRectWithSize(CGSizeMake(maxDateWidth, CGFloat.max),
                                                                              options: .UsesLineFragmentOrigin,
                                                                              attributes: [NSFontAttributeName: dateFont!],
                                                                              context: nil).size.height
            dateHeight += dateLabelTopMargin
        } else {
            dateHeight = 0
        }
        
        // Descriptions
        var descHeight : CGFloat = 0
        if let desc = photo.desc {
            let maxDescWidth = width - contentLeftMargin - descLabelRightMargin
            let formattedDesc = formattedDescriptionString(photo)
            if formattedDesc != nil {
                // Calculate HTML string height
                descHeight = formattedDesc!.boundingRectWithSize(CGSizeMake(maxDescWidth, CGFloat.max),
                                                                       options: .UsesLineFragmentOrigin,
                                                                       context: nil).size.height
            } else {
                // Calculate plain string height
                descHeight = NSString(string : desc).boundingRectWithSize(CGSizeMake(maxDescWidth, CGFloat.max),
                                                                          options: .UsesLineFragmentOrigin,
                                                                          attributes: [NSFontAttributeName: descFont!],
                                                                          context: nil).size.height
            }
            
            descHeight += descLabelTopMargin
        } else {
            descHeight = 0
        }

        return titleHeight + dateHeight + descHeight
    }
    
    // MARK: - Private
    
    private func formattedDescriptionString(photo : PhotoModel) -> NSAttributedString? {
        guard let desc = photo.desc else { return nil }
        
        // Try to retrieve from cache
        let cachedDesc = cacheController.getFormattedDescription(photo.photoId)
        if cachedDesc != nil {
            return cachedDesc
        }
        
        let descStringWithStyles = NSString(format:"<span style=\"color: #989898; font-family: \(descFont!.fontName); font-size: \(descFont!.pointSize)\">%@</span>", desc) as String
        guard let data = descStringWithStyles.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
        
        let options : [String : AnyObject] = [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                              NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding]
        
        var formattedDesc : NSAttributedString?
        do {
            formattedDesc = try NSAttributedString(data: data, options: options, documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            formattedDesc = nil
        }
        
        if formattedDesc != nil {
            cacheController.setFormattedDescription(formattedDesc!, photoId: photo.photoId)
        }
        
        return formattedDesc
    }
    
    private func displayDateString(photo : PhotoModel) -> String? {
        if photo.creationDate == nil {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter.stringFromDate(photo.creationDate!)
    }
    
    override func entranceAnimationWillBegin() {
        titleLabel.alpha = 0
        dateLabel.alpha = 0
        descLabel.alpha = 0
        
        titleLabel.transform = CGAffineTransformMakeTranslation(0, 30)
        dateLabel.transform = CGAffineTransformMakeTranslation(0, 30)
        descLabel.transform = CGAffineTransformMakeTranslation(0, 30)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframeWithRelativeStartTime(0.3, relativeDuration: 1, animations: { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.transform = CGAffineTransformIdentity
        })
        
        UIView .addKeyframeWithRelativeStartTime(0.5, relativeDuration: 1, animations: { [weak self] in
            self?.dateLabel.alpha = 1
            self?.dateLabel.transform = CGAffineTransformIdentity
        })
        
        UIView .addKeyframeWithRelativeStartTime(0.7, relativeDuration: 1, animations: { [weak self] in
            self?.descLabel.alpha = 1
            self?.descLabel.transform = CGAffineTransformIdentity
        })
    }
}
