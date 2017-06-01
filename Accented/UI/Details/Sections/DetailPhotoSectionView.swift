//
//  DetailPhotoSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailPhotoSectionView: DetailSectionViewBase, DetailLightBoxAnimationSource, DetailLightBoxAnimation {

    override var sectionId: String {
        return "photo"
    }
    
    var photoView = UIImageView()
    fileprivate static var leftMargin : CGFloat = 0
    fileprivate static var rightMargin : CGFloat = 0
    
    override func initialize() {
        super.initialize()
        
        photoView.contentMode = .scaleAspectFit
        contentView.addSubview(photoView)
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard photo != nil else { return }
        
        if let imageUrl = PhotoRenderer.preferredImageUrl(photo!) {
            photoView.sd_setImage(with: imageUrl)
        } else {
            photoView.image = nil
        }

        let h = self.contentView.bounds.height
        let photoWidth = maxWidth - DetailPhotoSectionView.leftMargin - DetailPhotoSectionView.rightMargin
        photoView.frame = CGRect(x: DetailPhotoSectionView.leftMargin, y: 0, width: photoWidth, height: h)
    }
    
    // MARK: - Measurements
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        return DetailPhotoSectionView.estimatedPhotoViewHeight(photo, width: maxWidth)
    }
    
    fileprivate static func estimatedPhotoViewHeight(_ photo : PhotoModel, width : CGFloat) -> CGFloat {
        let photoAspectRatio = photo.height / photo.width
        return width * photoAspectRatio
    }
    
    static func targetRectForPhotoView(_ photo : PhotoModel, width: CGFloat) -> CGRect {
        let photoWidth = width - DetailPhotoSectionView.leftMargin - DetailPhotoSectionView.rightMargin
        let height = DetailPhotoSectionView.estimatedPhotoViewHeight(photo, width: photoWidth)
        return CGRect(x: DetailPhotoSectionView.leftMargin, y: 0, width: photoWidth, height: height)
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
