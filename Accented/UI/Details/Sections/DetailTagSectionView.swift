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

    // Label showing when there're no tags in the photo
    private var noTagsLabel = UILabel()
    
    private let contentLeftMargin : CGFloat = 15
    private let contentRightMargin : CGFloat = 30
    
    // Fixed content height when there're no tags in the photo
    private var noTagsSectionHeight : CGFloat = 40
    
    // Cached content view size
    private var contentViewSize : CGSize?
    
    // Tags content view
    private var tagsContentView : DetailTagSectionContentView!
    
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
    
    override func createContentView() {
        tagsContentView = DetailTagSectionContentView()
        tagsContentView.cacheController = cacheController
        contentView = tagsContentView
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        
        tagsContentView.photo = photo
        
        if photo!.tags.count > 0 {
            noTagsLabel.hidden = true
            tagsContentView.hidden = false
        } else {
            noTagsLabel.hidden = false
            tagsContentView.hidden = true
        }
        
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }

        let contentSize = cacheController.getTagSectionContentSize(photo!.photoId)
        if contentSize != nil {
            var f = tagsContentView.frame
            f.origin.x = contentLeftMargin
            f.size.width = contentSize!.width - contentLeftMargin - contentRightMargin
            f.size.height = contentSize!.height
            tagsContentView.frame = f
        }
    }
    
    // MARK: - Measurements
    
    override func calculatedHeightForPhoto(photo: PhotoModel, width: CGFloat) -> CGFloat {
        if photo.tags.count == 0 {
            return noTagsSectionHeight + sectionTitleHeight
        } else {
            return tagsContentView.contentViewHeightForPhoto(photo, width: width) + sectionTitleHeight
        }
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
