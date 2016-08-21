//
//  DetailTagSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailTagSectionView: DetailSectionViewBase {

    override var sectionId: String {
        return "tags"
    }

    private var tagButtons = [UIButton]()
    private var noTagsLabel = UILabel()
    private let hGap : CGFloat = 6
    private let vGap : CGFloat = 6
    private let contentLeftMargin : CGFloat = 15
    private let contentRightMargin : CGFloat = 30
    
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
        noTagsLabel.font = descFont
        noTagsLabel.textColor = descColor
        noTagsLabel.leadingAnchor.constraintEqualToAnchor(self.contentView.leadingAnchor).active = true
        noTagsLabel.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
        noTagsLabel.hidden = true
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        
        // Remove all tag buttons
        for button in tagButtons {
            button.removeFromSuperview()
        }
        
        tagButtons.removeAll()
        
        if photo!.tags.count > 0 {
            noTagsLabel.hidden = true
            for tag in photo!.tags {
                let button = createTagButton()
                button.setTitle(tag, forState: .Normal)
                button.sizeToFit()
                contentView.addSubview(button)
                tagButtons.append(button)
            }
        } else {
            noTagsLabel.hidden = false
        }
        
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }
        guard tagButtons.count == photo!.tags.count else { return }
        
        for (index, tagButton) in tagButtons.enumerate() {
            let cachedFrame = cacheController.getTagButtonFrame(photo!.photoId, tagIndex: index)
            if cachedFrame != nil {
                tagButton.frame = cachedFrame!
            }
        }
    }
    
    // MARK: - Measurements
    
    override func calculatedHeightForPhoto(photo: PhotoModel, width: CGFloat) -> CGFloat {
        if photo.tags.count == 0 {
            return noTagsSectionHeight + sectionTitleHeight
        }
        
        // Create a measurement tag button
        let measurementButton = createTagButton()
        var nextX : CGFloat = contentLeftMargin
        var nextY : CGFloat = 0
        var maxRowHeight : CGFloat = 0
        let maxContentWidth = maxWidth - contentLeftMargin - contentRightMargin
        var calculatedSectionHeight : CGFloat = 0
        
        for (index, tag) in photo.tags.enumerate() {
            measurementButton.setTitle(tag, forState: .Normal)
            measurementButton.sizeToFit()
            
            var f = measurementButton.frame
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
            
            // Cache the frame for the tag button
            cacheController.setTagButtonFrame(f, photoId: photo.photoId, tagIndex: index)
            
            calculatedSectionHeight = nextY + maxRowHeight
        }
        
        return calculatedSectionHeight + sectionTitleHeight
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
    
    // MARK : - Private
    
    private func createTagButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.setTitleColor(UIColor.whiteColor(), forState:.Normal)
        button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Medium", size: 15)
        button.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        button.backgroundColor = UIColor(red: 32 / 255.0, green: 32 / 255.0, blue: 32 / 255.0, alpha: 1)
        button.layer.cornerRadius = 4
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 1
        return button
    }
}
