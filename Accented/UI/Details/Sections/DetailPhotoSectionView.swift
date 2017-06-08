//
//  DetailPhotoSectionView.swift
//  Accented
//
//  Hero image section in detail page
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailPhotoSectionView: DetailSectionViewBase, DetailLightBoxAnimationSource, DetailLightBoxAnimation {
    var photoView = UIImageView()
    
    override func initialize() {
        super.initialize()
        
        photoView.contentMode = .scaleAspectFit
        contentView.addSubview(photoView)
        
        if let imageUrl = PhotoRenderer.preferredImageUrl(photo) {
            photoView.sd_setImage(with: imageUrl)
        } else {
            photoView.image = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoView.frame = contentView.bounds
    }
    
    // MARK: - Measurements
    
    override func calculateContentHeight(maxWidth: CGFloat) -> CGFloat {
        return DetailPhotoSectionView.estimatedPhotoViewHeight(photo, width: width)
    }
    
    private static func estimatedPhotoViewHeight(_ photo : PhotoModel, width : CGFloat) -> CGFloat {
        let photoAspectRatio = photo.height / photo.width
        return width * photoAspectRatio
    }
    
    static func targetRectForPhotoView(_ photo : PhotoModel, width: CGFloat) -> CGRect {
        let height = DetailPhotoSectionView.estimatedPhotoViewHeight(photo, width: width)
        return CGRect(x: 0, y: 0, width: width, height: height)
    }

    // MARK: - Entrance Animation
    
    override func entranceAnimationWillBegin() {
        photoView.isHidden = true
    }
    
    override func entranceAnimationDidFinish() {
        photoView.isHidden = false
    }
    
    // MARK: - DetailLightBoxAnimationSource
    
    func sourceImageViewForLightBoxTransition() -> UIImageView {
        return photoView
    }
    
    // MARK: - DetailLightBoxAnimation
    
    func lightBoxTransitionWillBegin() {
        // Hide the photo view
        photoView.isHidden = true
    }
    
    func lightboxTransitionDidFinish() {
        
    }
    
    func performLightBoxTransition() {
        photoView.isHidden = false
    }
    
    func desitinationRectForSelectedLightBoxPhoto(_ photo: PhotoModel) -> CGRect {
        // No-op
        return CGRect.zero
    }
    
}
