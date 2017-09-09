//
//  GalleryListRenderer.swift
//  Accented
//
//  Created by Tiangong You on 9/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class GalleryListRenderer: UICollectionViewCell {

    @IBOutlet weak var renderer: GalleryRenderer!
    
    var gallery : GalleryModel? {
        didSet {
            renderer.gallery = gallery
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
