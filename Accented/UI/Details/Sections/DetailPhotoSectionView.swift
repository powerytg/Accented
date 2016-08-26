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
    
    private var photoView = UIImageView()
    private static var leftMargin : CGFloat = 5
    private static var rightMargin : CGFloat = 0
    
    override func initialize() {
        super.initialize()
        
        photoView.contentMode = .ScaleAspectFit
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
            photoView.sd_setImageWithURL(imageUrl)
        } else {
            photoView.image = nil
        }

        let h = CGRectGetHeight(self.contentView.bounds)
        let photoWidth = maxWidth - DetailPhotoSectionView.leftMargin - DetailPhotoSectionView.rightMargin
        photoView.frame = CGRectMake(DetailPhotoSectionView.leftMargin, 0, photoWidth, h)
        photoView.layer.shadowColor = UIColor.blackColor().CGColor
        photoView.layer.shadowOpacity = 0.5
        photoView.layer.shadowRadius = 5
        photoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        photoView.layer.shadowPath = UIBezierPath(rect: CGRectMake(DetailPhotoSectionView.leftMargin, 0, photoWidth, h)).CGPath
    }
    
    // MARK: - Measurements
    
    override func calculatedHeightForPhoto(photo: PhotoModel, width: CGFloat) -> CGFloat {
        return DetailPhotoSectionView.estimatedPhotoViewHeight(photo, width: maxWidth)
    }
    
    private static func estimatedPhotoViewHeight(photo : PhotoModel, width : CGFloat) -> CGFloat {
        let photoAspectRatio = photo.height / photo.width
        return width * photoAspectRatio
    }
    
    static func targetRectForPhotoView(photo : PhotoModel, width: CGFloat) -> CGRect {
        let photoWidth = width - DetailPhotoSectionView.leftMargin - DetailPhotoSectionView.rightMargin
        let height = DetailPhotoSectionView.estimatedPhotoViewHeight(photo, width: photoWidth)
        return CGRectMake(DetailPhotoSectionView.leftMargin, 0, photoWidth, height)
    }

    // MARK: - Entrance Animation
    
    override func entranceAnimationWillBegin() {
        photoView.hidden = true
    }
    
    override func entranceAnimationDidFinish() {
        photoView.hidden = false
    }
    
    // MARK: - DetailLightBoxAnimationSource
    
    func sourceImageViewForLightBoxTransition() -> UIImageView {
        return photoView
    }
    
    // MARK: - DetailLightBoxAnimation
    
    func lightBoxTransitionWillBegin() {
        // Hide the photo view
        photoView.hidden = true
    }
    
    func lightboxTransitionDidFinish() {
        
    }
    
    func performLightBoxTransition() {
        photoView.hidden = false
    }
    
    func desitinationRectForSelectedLightBoxPhoto(photo: PhotoModel) -> CGRect {
        // No-op
        return CGRectZero
    }
    
}
