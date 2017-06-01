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
    fileprivate var noTagsLabel = UILabel()
    
    fileprivate let contentLeftMargin : CGFloat = 15
    fileprivate let contentRightMargin : CGFloat = 30
    
    // Fixed content height when there're no tags in the photo
    fileprivate var noTagsSectionHeight : CGFloat = 40
    
    // Cached content view size
    fileprivate var contentViewSize : CGSize?
    
    // Tags content view
    fileprivate var tagsContentView : DetailTagSectionContentView!
    
    override var title: String? {
        return "TAGS"
    }
    
    override func initialize() {
        super.initialize()
                
        // When there're no tags defined for the image, show this label instead
        addSubview(noTagsLabel)
        noTagsLabel.translatesAutoresizingMaskIntoConstraints = false
        noTagsLabel.text = "This photo has no tags"
        noTagsLabel.font = ThemeManager.sharedInstance.currentTheme.descFont
        noTagsLabel.textColor = ThemeManager.sharedInstance.currentTheme.descTextColor
        noTagsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentLeftMargin).isActive = true
        noTagsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: sectionTitleHeight).isActive = true
        noTagsLabel.isHidden = true
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
            noTagsLabel.isHidden = true
            tagsContentView.isHidden = false
        } else {
            noTagsLabel.isHidden = false
            tagsContentView.isHidden = true
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
            f.size.width = contentSize!.width
            f.size.height = contentSize!.height
            tagsContentView.frame = f
        }
    }
    
    // MARK: - Measurements
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        if photo.tags.count == 0 {
            return noTagsSectionHeight + sectionTitleHeight
        } else {
            let maxContentWidth = width - contentLeftMargin - contentRightMargin
            return tagsContentView.contentViewHeightForPhoto(photo, width: maxContentWidth) + sectionTitleHeight
        }
    }
    
    // MARK: - Animations
    
    override func entranceAnimationWillBegin() {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 30, y: 0)
    }
    
    override func performEntranceAnimation() {
        UIView .addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1, animations: { [weak self] in
            self?.alpha = 1
            self?.transform = CGAffineTransform.identity
            })
    }
}
