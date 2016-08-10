//
//  DetailPhotoSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailPhotoSectionView: DetailSectionViewBase, DetailLightBoxAnimationSource, DetailLightBoxAnimation {

    private var photoView = UIImageView()
    private var calculatedPhotoHeight : CGFloat = 0
    private static var leftMargin : CGFloat = 5
    private static var rightMargin : CGFloat = 0
    
    override init(maxWidth: CGFloat) {
        super.init(maxWidth: maxWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        super.initialize()
        
        photoView.contentMode = .ScaleAspectFit
        contentView.addSubview(photoView)
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        
        if let imageUrl = preferredImageUrl() {
            photoView.af_setImageWithURL(imageUrl)
        }
        
        // Calculate desired height
        calculatedPhotoHeight = DetailPhotoSectionView.estimatedPhotoViewHeight(photo!, width: maxWidth)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard photo != nil else { return }
        
        let photoWidth = maxWidth - DetailPhotoSectionView.leftMargin - DetailPhotoSectionView.rightMargin
        photoView.layer.shadowColor = UIColor.blackColor().CGColor
        photoView.layer.shadowOpacity = 0.5
        photoView.layer.shadowRadius = 5
        photoView.layer.shadowOffset = CGSize(width: 0, height: 0)
        photoView.layer.shadowPath = UIBezierPath(rect: CGRectMake(DetailPhotoSectionView.leftMargin, 0, photoWidth, calculatedPhotoHeight)).CGPath
        
        photoView.frame = CGRectMake(DetailPhotoSectionView.leftMargin, 0, photoWidth, calculatedPhotoHeight)
    }
    
    // MARK: - Measurements
    
    override func estimatedHeight(width : CGFloat) -> CGFloat {
        if photo == nil {
            return 0
        }
        
        return calculatedPhotoHeight
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
    
    // MARK: - Private
    
    private func preferredImageUrl() -> NSURL? {
        if let url = photo!.imageUrls[.Large] {
            return NSURL(string: url)
        } else if let url = photo!.imageUrls[.Medium] {
            return NSURL(string: url)
        } else if let url = photo!.imageUrls[.Small] {
            return NSURL(string: url)
        } else {
            return nil
        }
    }
    
}
