//
//  DetailPhotoSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/6/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailPhotoSectionView: DetailSectionViewBase {

    private var photoView = UIImageView()
    private var calculatedPhotoHeight : CGFloat = 0
    
    override init(maxWidth: CGFloat) {
        super.init(maxWidth: maxWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize() {
        super.initialize()
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .ScaleAspectFit
        addSubview(photoView)
    }
    
    override func photoModelDidChange() {
        guard photo != nil else { return }
        
        if let imageUrl = preferredImageUrl() {
            photoView.af_setImageWithURL(imageUrl)
        }
        
        // Calculate desired height
        calculatedPhotoHeight = DetailPhotoSectionView.estimatedPhotoViewHeight(photo!, width: maxWidth)
        
        // Update photo view constraints
        let views = ["photoView" : self.photoView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[photoView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[photoView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoView.layer.shadowColor = UIColor.blackColor().CGColor
        photoView.layer.shadowOpacity = 0.5
        photoView.layer.shadowRadius = 5
        photoView.layer.shadowOffset = CGSize(width: 0, height: 2)
        photoView.layer.shadowPath = UIBezierPath(rect: CGRectMake(0, 0, maxWidth, calculatedPhotoHeight)).CGPath
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
