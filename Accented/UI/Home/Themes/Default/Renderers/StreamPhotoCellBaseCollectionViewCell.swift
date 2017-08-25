//
//  StreamPhotoCellBaseCollectionViewCell.swift
//  Accented
//
//  Base renderer for a photo cell in home stream
//
//  Created by You, Tiangong on 8/25/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class StreamPhotoCellBaseCollectionViewCell: UICollectionViewCell {
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

    func initialize() {
        // Base class do nothing
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        renderer.photo = photo
        renderer.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        renderer.photo = nil
    }
}
