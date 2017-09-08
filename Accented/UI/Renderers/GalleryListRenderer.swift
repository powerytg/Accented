//
//  GalleryListRenderer.swift
//  Accented
//
//  Created by You, Tiangong on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GalleryListRenderer: UICollectionViewCell {

    @IBOutlet weak var galleryView: GalleryRenderer!
    
    var gallery : GalleryModel? {
        didSet {
            galleryView.gallery = gallery
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
