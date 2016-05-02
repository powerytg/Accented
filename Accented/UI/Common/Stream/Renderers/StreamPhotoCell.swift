//
//  StreamPhotoCell.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamPhotoCell: UICollectionViewCell {

    var renderer: PhotoRenderer!
    var photo : PhotoModel?
    var effectLayer : CALayer {
        return self.layer
    }
    
    override init(frame: CGRect) {
        renderer = PhotoRenderer()
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() -> Void {
        self.contentView.addSubview(renderer)
        self.contentView.clipsToBounds = true
        
        // Shadow effect
        effectLayer.masksToBounds = false
        effectLayer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
        effectLayer.shadowColor = UIColor.blackColor().CGColor
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
        
        effectLayer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
        
        renderer.photo = photo
        renderer.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        renderer.photo = nil
    }

}
