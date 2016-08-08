//
//  swift
//  Accented
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailDescriptionSectionView: DetailSectionViewBase {

    private var titleLabel : UILabel = UILabel()
    private var dateLabel : UILabel = UILabel()
    private var descLabel : UILabel = UILabel()
    
    private let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 34)
    private let dateFont = UIFont(name: "HelveticaNeue", size: 14)
    private let descFont = UIFont(name: "AvenirNextCondensed-Regular", size: 18)
    
    private let contentLeftMargin : CGFloat = 15
    private let titleLabelTopMargin : CGFloat = 12
    private let titleLabelRightMargin : CGFloat = 70
    private let dateLabelTopMargin : CGFloat = 10
    private let dateLabelRightMargin : CGFloat = 120
    private let descLabelTopMargin : CGFloat = 10
    private let descLabelRightMargin : CGFloat = 30

    private var calculatedSectionHeight : CGFloat = 0
    
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
        descLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        descLabel.preferredMaxLayoutWidth = maxWidth - contentLeftMargin - descLabelRightMargin
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .ByWordWrapping
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
        
        titleLabel.text = photo!.title
        
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
        
        descLabel.text = photo!.desc
        
        // Calculate the cache estimated section height
        calculatedSectionHeight = estimatedSectionHeight(photo!, width: maxWidth)
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Measurments
    
    private func estimatedSectionHeight(photo : PhotoModel, width : CGFloat) -> CGFloat {
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
            descHeight = NSString(string : desc).boundingRectWithSize(CGSizeMake(maxDescWidth, CGFloat.max),
                                                                              options: .UsesLineFragmentOrigin,
                                                                              attributes: [NSFontAttributeName: descFont!],
                                                                              context: nil).size.height
            descHeight += descLabelTopMargin
        } else {
            descHeight = 0
        }

        return titleHeight + dateHeight + descHeight
    }
    
    override func estimatedHeight(width: CGFloat) -> CGFloat {
        if photo == nil {
            return 0
        } else {
            return calculatedSectionHeight
        }
    }
    
    // MARK: - Private
    
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
