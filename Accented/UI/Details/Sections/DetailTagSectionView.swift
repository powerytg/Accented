//
//  DetailTagSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailTagSectionView: DetailSectionViewBase {

    private let hGap : CGFloat = 6
    private let vGap : CGFloat = 6
    private let contentRightMargin : CGFloat = 30
    
    // Cached tag button frames
    private var tagButtonFrames = [CGRect]()
    
    // Cached content view size
    private var contentViewSize : CGSize?
    
    private var tagButtons = [TagButton]()

    override var title: String? {
        return "TAGS"
    }
    
    override func initialize() {
        super.initialize()
        buildTagButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo.tags.count != 0 else { return }
        
        for (index, _) in photo.tags.enumerated() {
            let button = tagButtons[index]
            let f = tagButtonFrames[index]
            button.frame = f
            button.setNeedsLayout()
        }
    }
    
    private func buildTagButtons() {
        for tag in photo.tags {
            let button = TagButton()
            button.setTitle(tag, for: .normal)
            button.sizeToFit()
            button.addTarget(self, action: #selector(tagButtonDidTap(_:)), for: .touchUpInside)

            contentView.addSubview(button)
            tagButtons.append(button)
        }
    }
    
    @objc private func tagButtonDidTap(_ sender : TagButton) {
        let tappedIndex = tagButtons.index(of: sender)
        NavigationService.sharedInstance.navigateToSearchResultPage(tag: photo.tags[tappedIndex!])
    }
    
    // MARK: - Measurements
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        if photo.tags.count == 0 {
            return 0
        }
        
        tagButtonFrames.removeAll()
        let availableWidth = maxWidth - contentRightMargin
        var nextX : CGFloat = contentLeftPadding
        var nextY : CGFloat = 0
        var maxRowHeight : CGFloat = 0
        var calculatedSectionHeight : CGFloat = 0
        
        for button in tagButtons {
            var f = button.frame
            
            if f.height > maxRowHeight {
                maxRowHeight = f.height
            }
            
            if nextX + f.width > availableWidth {
                // Start a new row
                nextX = contentLeftPadding
                nextY += maxRowHeight + vGap
                maxRowHeight = f.height
                f.origin.x = nextX
                f.origin.y = nextY
                nextX += f.width + hGap
            } else {
                // Put the button to the right of its sibling
                f.origin.x = nextX
                f.origin.y = nextY
                nextX += f.width + hGap
            }
            
            // Cache the frame for the tag button
            tagButtonFrames.append(f)
            calculatedSectionHeight = nextY + maxRowHeight
        }
        
        // Cached the size of the content view
        return calculatedSectionHeight + sectionTitleHeight
    }
    
    // MARK: - Animations
    
    override func entranceAnimationWillBegin() {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: 30)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: { [weak self] in
            self?.alpha = 1
            self?.transform = CGAffineTransform.identity
            })
    }
}
