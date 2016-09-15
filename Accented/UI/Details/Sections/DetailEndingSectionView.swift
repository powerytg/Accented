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
    fileprivate let contentHeight : CGFloat = 80

    // Separator symbol
    fileprivate var separatorImageView = UIImageView(image : UIImage(named : "DetailEndingSymbol"))
    
    override func initialize() {
        super.initialize()
        
        contentView.addSubview(separatorImageView)
        separatorImageView.alpha = 0.5
        separatorImageView.translatesAutoresizingMaskIntoConstraints = false
        separatorImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        separatorImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    override func calculatedHeightForPhoto(_ photo: PhotoModel, width: CGFloat) -> CGFloat {
        return contentHeight
    }
}
