//
//  DetailEndingSectionView.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailEndingSectionView: DetailSectionViewBase {

    override var sectionId: String {
        return "ending"
    }

    // Fixed content size
    private let contentHeight : CGFloat = 80

    // Separator symbol
    private var separatorImageView = UIImageView(image : UIImage(named : "DetailEndingSymbol"))
    
    override func initialize() {
        super.initialize()
        
        contentView.addSubview(separatorImageView)
        separatorImageView.alpha = 0.5
        separatorImageView.translatesAutoresizingMaskIntoConstraints = false
        separatorImageView.centerXAnchor.constraintEqualToAnchor(self.contentView.centerXAnchor).active = true
        separatorImageView.centerYAnchor.constraintEqualToAnchor(self.contentView.centerYAnchor).active = true
    }
    
    override func calculatedHeightForPhoto(photo: PhotoModel, width: CGFloat) -> CGFloat {
        return contentHeight
    }
}
