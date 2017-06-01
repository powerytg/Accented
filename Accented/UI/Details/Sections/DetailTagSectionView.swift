//
//  DetailTagSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailTagSectionView: DetailSectionViewBase {

    fileprivate let contentRightMargin : CGFloat = 30
    
    // Cached content view size
    fileprivate var contentViewSize : CGSize?
    
    override var title: String? {
        return "TAGS"
    }
    
    override func initialize() {
        super.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo.tags.count != 0 else { return }
    }
    
    // MARK: - Measurements
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        if photo.tags.count == 0 {
            return 0
        } else {
            let maxContentWidth = width - contentLeftPadding - contentRightMargin
            return 0
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
