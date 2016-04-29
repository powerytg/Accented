//
//  StreamPhotoCollectionViewCell.swift
//  Accented
//
//  Created by Tiangong You on 4/22/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamPhotoCollectionViewCell: UICollectionViewCell {

    var renderer: PhotoRenderer!
    var photo : PhotoModel?

    override init(frame: CGRect) {
        renderer = PhotoRenderer()
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() -> Void {
        renderer.translatesAutoresizingMaskIntoConstraints = false
        renderer.clipsToBounds = true
        
        self.contentView.addSubview(renderer)
        self.contentView.clipsToBounds = true
        
        let views = ["renderer" : renderer]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[renderer]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[renderer]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if renderer != nil {
            renderer.photo = photo
        }        
    }
    
    override func prepareForReuse() {
        renderer.photo = nil
    }
}
