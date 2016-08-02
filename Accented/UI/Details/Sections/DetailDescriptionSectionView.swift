//
//  DetailDescriptionSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailDescriptionSectionView: DetailSectionViewBase {

    var descLabel : UILabel!
    private static let descFont = UIFont(name: "AvenirNextCondensed-Regular", size: 20)
    private static let descLabelTopMargin : CGFloat = 10
    private static let descLabelLeftMargin : CGFloat = 30
    private static let descLabelRightMargin : CGFloat = 30

    override func initialize() {
        super.initialize()
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.65)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Desc label
        descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = DetailDescriptionSectionView.descFont
        descLabel.textColor = UIColor(red: 152 / 255.0, green: 152 / 255.0, blue: 152 / 255.0, alpha: 1)
        descLabel.preferredMaxLayoutWidth = maxWidth - DetailDescriptionSectionView.descLabelLeftMargin - DetailDescriptionSectionView.descLabelRightMargin
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .ByWordWrapping
        addSubview(descLabel)
        
        // Constaints
        descLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: DetailDescriptionSectionView.descLabelLeftMargin).active = true
        descLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: DetailDescriptionSectionView.descLabelRightMargin).active = true
        descLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: DetailDescriptionSectionView.descLabelTopMargin).active = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descLabel.text = photo.desc
    }
    
    override func estimatedHeight(width: CGFloat) -> CGFloat {
        if let desc = photo.desc {
            // Calculate desc text
            let descSize = NSString(string : desc).boundingRectWithSize(CGSizeMake(maxWidth, CGFloat.max),
                                                                               options: .UsesLineFragmentOrigin,
                                                                               attributes: [NSFontAttributeName: DetailDescriptionSectionView.descFont!],
                                                                               context: nil).size
            
            return descSize.height + DetailDescriptionSectionView.descLabelTopMargin
            
        } else {
            return 0
        }
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
