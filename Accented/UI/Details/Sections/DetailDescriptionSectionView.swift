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
    
    fileprivate var titleLabel = UILabel()
    fileprivate var dateLabel = UILabel()
    fileprivate var descLabel = TTTAttributedLabel(frame: CGRect.zero)
    
    fileprivate let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 34)
    fileprivate let dateFont = UIFont(name: "HelveticaNeue", size: 14)    
    fileprivate let linkColor = ThemeManager.sharedInstance.currentTheme.linkColor
    fileprivate let linkPressColor = ThemeManager.sharedInstance.currentTheme.linkHighlightColor
    
    fileprivate let contentLeftMargin : CGFloat = 15
    fileprivate let titleLabelTopMargin : CGFloat = 12
    fileprivate let titleLabelRightMargin : CGFloat = 70
    fileprivate let dateLabelTopMargin : CGFloat = 10
    fileprivate let dateLabelRightMargin : CGFloat = 120
    fileprivate let descLabelTopMargin : CGFloat = 10
    fileprivate let descLabelRightMargin : CGFloat = 30
    
    // Constraints
    fileprivate var descLabelTopConstraint : NSLayoutConstraint?
    
    override func initialize() {
        super.initialize()
        
        // Title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleFont
        titleLabel.textColor = UIColor.white
        titleLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - titleLabelRightMargin
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)

        // Date label
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = dateFont
        dateLabel.textColor = UIColor.white
        dateLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - dateLabelRightMargin
        contentView.addSubview(dateLabel)
        
        // Desc label
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = descFont
        descLabel.textColor = descColor
        descLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - descLabelRightMargin
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.linkAttributes = [NSForegroundColorAttributeName : linkColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        descLabel.activeLinkAttributes = [NSForegroundColorAttributeName : linkPressColor, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleNone.rawValue]
        contentView.addSubview(descLabel)
        
        // Constaints
        titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: contentLeftMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: titleLabelTopMargin).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: dateLabelTopMargin).isActive = true

        descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
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
            dateLabel.isHidden = false
            
            descLabelTopConstraint?.isActive = false
            descLabelTopConstraint = descLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: descLabelTopMargin)
            descLabelTopConstraint?.isActive = true
        } else{
            dateLabel.isHidden = true
            
            descLabelTopConstraint?.isActive = false
            descLabelTopConstraint = descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: descLabelTopMargin)
            descLabelTopConstraint?.isActive = true
        }
        
        // Descriptions
        if let formattedDesc = formattedDescriptionString(photo!) {
            descLabel.setText(formattedDesc)
        } else {
            descLabel.text = photo!.desc
        }
    }
    
    // MARK: - Measurments
    
    override func calculatedHeightForPhoto(_ photo : PhotoModel, width : CGFloat) -> CGFloat {
        // Title
        let maxTitleWidth = width - contentLeftMargin - titleLabelRightMargin
        var titleHeight = NSString(string : photo.title).boundingRect(with: CGSize(width: maxTitleWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                            options: .usesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: titleFont!],
                                                                            context: nil).size.height
        titleHeight += titleLabelTopMargin
        
        // Date
        var dateHeight : CGFloat = 0
        if let date = displayDateString(photo) {
            let maxDateWidth = width - contentLeftMargin - dateLabelRightMargin
            dateHeight = NSString(string : date).boundingRect(with: CGSize(width: maxDateWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                              options: .usesLineFragmentOrigin,
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
                descHeight = formattedDesc!.boundingRect(with: CGSize(width: maxDescWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                       options: .usesLineFragmentOrigin,
                                                                       context: nil).size.height
            } else {
                // Calculate plain string height
                descHeight = NSString(string : desc).boundingRect(with: CGSize(width: maxDescWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                          options: .usesLineFragmentOrigin,
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
    
    fileprivate func formattedDescriptionString(_ photo : PhotoModel) -> NSAttributedString? {
        guard let desc = photo.desc else { return nil }
        
        // Try to retrieve from cache
        let cachedDesc = cacheController.getFormattedDescription(photo.photoId)
        if cachedDesc != nil {
            return cachedDesc
        }
        
        let descStringWithStyles = NSString(format:"<span style=\"color: #989898; font-family: \(descFont!.fontName); font-size: \(descFont!.pointSize)\">%@</span>" as NSString, desc) as String
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
        
        if formattedDesc != nil {
            cacheController.setFormattedDescription(formattedDesc!, photoId: photo.photoId)
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
