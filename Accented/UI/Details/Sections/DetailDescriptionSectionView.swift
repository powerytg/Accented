//
//  DetailDescriptionSectionView.swift
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
    
    private static let titleFont = UIFont(name: "HelveticaNeue-Thin", size: 30)
    private static let dateFont = UIFont(name: "HelveticaNeue-Medium", size: 16)
    private static let descFont = UIFont(name: "AvenirNextCondensed-Regular", size: 20)
    
    private static let contentLeftMargin : CGFloat = 15
    private static let titleLabelTopMargin : CGFloat = 8
    private static let titleLabelRightMargin : CGFloat = 70
    private static let dateLabelTopMargin : CGFloat = 10
    private static let dateLabelRightMargin : CGFloat = 120
    private static let descLabelTopMargin : CGFloat = 10
    private static let descLabelRightMargin : CGFloat = 30

    private var calculatedSectionHeight : CGFloat = 0
    
    // Constraints
    private var descLabelTopConstraint : NSLayoutConstraint?
    
    override func initialize() {
        super.initialize()
        
        // Title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = DetailDescriptionSectionView.titleFont
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.preferredMaxLayoutWidth = maxWidth - DetailDescriptionSectionView.contentLeftMargin - DetailDescriptionSectionView.titleLabelRightMargin
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .ByWordWrapping
        addSubview(titleLabel)

        // Date label
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = DetailDescriptionSectionView.dateFont
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.preferredMaxLayoutWidth = maxWidth - DetailDescriptionSectionView.contentLeftMargin - DetailDescriptionSectionView.dateLabelRightMargin
        addSubview(dateLabel)
        
        // Desc label
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = DetailDescriptionSectionView.descFont
        descLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        descLabel.preferredMaxLayoutWidth = maxWidth - DetailDescriptionSectionView.contentLeftMargin - DetailDescriptionSectionView.descLabelRightMargin
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .ByWordWrapping
        addSubview(descLabel)
        
        // Constaints
        titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: DetailDescriptionSectionView.contentLeftMargin).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: DetailDescriptionSectionView.titleLabelTopMargin).active = true
        
        dateLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
        dateLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: DetailDescriptionSectionView.dateLabelTopMargin).active = true

        descLabel.leadingAnchor.constraintEqualToAnchor(titleLabel.leadingAnchor).active = true
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        
        titleLabel.text = photo!.title
        
        if let dateString = DetailDescriptionSectionView.displayDateString(photo!) {
            descLabel.text = dateString
            descLabel.hidden = false
            
            descLabelTopConstraint?.active = false
            descLabelTopConstraint = descLabel.topAnchor.constraintEqualToAnchor(dateLabel.bottomAnchor, constant: DetailDescriptionSectionView.descLabelTopMargin)
            descLabelTopConstraint?.active = true
        } else{
            descLabel.hidden = true
            
            descLabelTopConstraint?.active = false
            descLabelTopConstraint = descLabel.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: DetailDescriptionSectionView.descLabelTopMargin)
            descLabelTopConstraint?.active = true
        }
        
        descLabel.text = photo!.desc
        
        // Calculate the cache estimated section height
        calculatedSectionHeight = DetailDescriptionSectionView.estimatedSectionHeight(photo!, width: maxWidth)
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Measurments
    
    private static func estimatedSectionHeight(photo : PhotoModel, width : CGFloat) -> CGFloat {
        // Title
        let maxTitleWidth = width - DetailDescriptionSectionView.contentLeftMargin - DetailDescriptionSectionView.titleLabelRightMargin
        var titleHeight = NSString(string : photo.title).boundingRectWithSize(CGSizeMake(maxTitleWidth, CGFloat.max),
                                                                            options: .UsesLineFragmentOrigin,
                                                                            attributes: [NSFontAttributeName: DetailDescriptionSectionView.titleFont!],
                                                                            context: nil).size.height
        titleHeight += DetailDescriptionSectionView.titleLabelTopMargin
        
        // Date
        var dateHeight : CGFloat = 0
        if let date = DetailDescriptionSectionView.displayDateString(photo) {
            let maxDateWidth = width - DetailDescriptionSectionView.contentLeftMargin - DetailDescriptionSectionView.dateLabelRightMargin
            dateHeight = NSString(string : date).boundingRectWithSize(CGSizeMake(maxDateWidth, CGFloat.max),
                                                                              options: .UsesLineFragmentOrigin,
                                                                              attributes: [NSFontAttributeName: DetailDescriptionSectionView.dateFont!],
                                                                              context: nil).size.height
            dateHeight += DetailDescriptionSectionView.dateLabelTopMargin
        } else {
            dateHeight = 0
        }
        
        
        // Descriptions
        var descHeight : CGFloat = 0
        if let desc = photo.desc {
            descHeight = NSString(string : desc).boundingRectWithSize(CGSizeMake(width, CGFloat.max),
                                                                              options: .UsesLineFragmentOrigin,
                                                                              attributes: [NSFontAttributeName: DetailDescriptionSectionView.descFont!],
                                                                              context: nil).size.height
            descHeight += DetailDescriptionSectionView.descLabelTopMargin
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
    
    private static func displayDateString(photo : PhotoModel) -> String? {
        if photo.creationDate == nil {
            return nil
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        return dateFormatter.stringFromDate(photo.creationDate!)
    }
    
    override func entranceAnimationWillBegin() {
        self.alpha = 0
        self.transform = CGAffineTransformMakeTranslation(0, 30)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframeWithRelativeStartTime(0.3, relativeDuration: 1, animations: { [weak self] in
            self?.alpha = 1
            self?.transform = CGAffineTransformIdentity
            })
    }
}
