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
        self.contentView.addSubview(renderer)
        self.contentView.clipsToBounds = true
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
