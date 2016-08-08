//
//  DetailTagSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailTagSectionView: DetailSectionViewBase {

    private var tagButtons = [UIButton]()
    private var noTagsLabel = UILabel()
    private let hGap : CGFloat = 6
    private let vGap : CGFloat = 6
    private let contentLeftMargin : CGFloat = 15
    private let contentRightMargin : CGFloat = 30
    
    // Cached section height
    private var calculatedSectionHeight : CGFloat = 0
    
    // Fixed content height when there're no tags in the photo
    private var noTagsSectionHeight : CGFloat = 40
    
    override var title: String? {
        return "TAGS"
    }
    
    override func initialize() {
        super.initialize()
        
        // When there're no tags defined for the image, show this label instead
        contentView.addSubview(noTagsLabel)
        noTagsLabel.translatesAutoresizingMaskIntoConstraints = false
        noTagsLabel.text = "This photo has no tags"
        noTagsLabel.textColor = ThemeManager.sharedInstance.currentTheme.descTextColor
        noTagsLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        noTagsLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        noTagsLabel.hidden = true
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        
        // Remove all tag buttons
        for button in tagButtons {
            button.removeFromSuperview()
        }
        
        tagButtons.removeAll()
        calculatedSectionHeight = 0
        
        if photo!.tags.count > 0 {
            noTagsLabel.hidden = true
            
            // Create new tag buttons and calculate content size
            var nextX : CGFloat = contentLeftMargin
            var nextY : CGFloat = 0
            var maxRowHeight : CGFloat = 0
            let maxContentWidth = maxWidth - contentLeftMargin - contentRightMargin
            for tag in photo!.tags {
                let button = UIButton(type: .Custom)
                button.setTitle(tag, forState: .Normal)
                button.setTitleColor(UIColor.whiteColor(), forState:.Normal)
                button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Medium", size: 15)
                button.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
                button.backgroundColor = UIColor(red: 32 / 255.0, green: 32 / 255.0, blue: 32 / 255.0, alpha: 1)
                button.layer.cornerRadius = 4
                button.layer.borderColor = UIColor.blackColor().CGColor
                button.layer.borderWidth = 1
                button.sizeToFit()
                contentView.addSubview(button)
                tagButtons.append(button)
                
                var f = button.frame
                if CGRectGetHeight(f) > maxRowHeight {
                    maxRowHeight = CGRectGetHeight(f)
                }
                
                if nextX + CGRectGetWidth(f) > maxContentWidth {
                    // Start a new row
                    nextX = contentLeftMargin
                    nextY += maxRowHeight + vGap
                    maxRowHeight = CGRectGetHeight(f)
                    f.origin.x = nextX
                    f.origin.y = nextY
                    nextX += CGRectGetWidth(f) + hGap
                } else {
                    // Put the button to the right of its sibling
                    f.origin.x = nextX
                    f.origin.y = nextY
                    nextX += CGRectGetWidth(f) + hGap
                }
                
                button.frame = f
                calculatedSectionHeight = nextY + maxRowHeight
            }
        } else {
            noTagsLabel.hidden = false
            calculatedSectionHeight = noTagsSectionHeight
        }
        
        // Add section title height
        calculatedSectionHeight += sectionTitleHeight
    }

    override func estimatedHeight(width: CGFloat) -> CGFloat {
        return calculatedSectionHeight
    }
    
    // MARK: - Animations
    
    override func entranceAnimationWillBegin() {
        self.alpha = 0
        self.transform = CGAffineTransformMakeTranslation(30, 0)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframeWithRelativeStartTime(0.5, relativeDuration: 1, animations: { [weak self] in
            self?.alpha = 1
            self?.transform = CGAffineTransformIdentity
            })
    }
    
}
