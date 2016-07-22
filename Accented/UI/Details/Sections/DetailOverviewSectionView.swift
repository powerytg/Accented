//
//  DetailOverviewSectionView.swift
//  Accented
//
//  Created by You, Tiangong on 7/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailOverviewSectionView: DetailSectionViewBase {

    var photoView : UIImageView!
    var titleLabel : UILabel!
    
    private var calculatedPhotoHeight : CGFloat!
    
    override func initialize() {
        super.initialize()
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.textColor = UIColor.whiteColor()
        addSubview(titleLabel)
        
        photoView = UIImageView()
        photoView.contentMode = .ScaleAspectFill
        photoView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(photoView)

        titleLabel.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor, constant: 30).active = true
        titleLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: 30).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 50).active = true
        
        // Calculate photo height
        let photoAspectRatio = photo.height / photo.width
        self.calculatedPhotoHeight = maxWidth * photoAspectRatio
        
        photoView.topAnchor.constraintEqualToAnchor(titleLabel.bottomAnchor, constant: 20).active = true
        photoView.leadingAnchor.constraintEqualToAnchor(self.leadingAnchor).active = true
        photoView.widthAnchor.constraintEqualToConstant(maxWidth).active = true
        photoView.heightAnchor.constraintEqualToConstant(self.calculatedPhotoHeight).active = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) * 0.7
        titleLabel.text = photo.title;
        let preferredImageUrlString = photo.imageUrls[ImageSize.Large]!
        let imageUrl = NSURL(string: preferredImageUrlString)!
        photoView.af_setImageWithURL(imageUrl)
    }
    
    override func estimatedHeight(width: CGFloat) -> CGFloat {
        return self.calculatedPhotoHeight + 50;
    }
    
}
