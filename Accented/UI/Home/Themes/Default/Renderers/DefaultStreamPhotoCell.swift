//
//  StreamPhotoCell.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamPhotoCell: StreamPhotoCellBaseCollectionViewCell {

    var effectLayer : CALayer {
        return self.layer
    }
    
    override func initialize(){
        self.contentView.addSubview(renderer)
        self.contentView.clipsToBounds = true
        
        // Shadow effect
        effectLayer.masksToBounds = false
        effectLayer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        effectLayer.shadowColor = UIColor.black.cgColor
        effectLayer.shadowOpacity = 0.25
        effectLayer.shadowRadius = 5
        effectLayer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        effectLayer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
