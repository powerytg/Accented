//
//  ThemeSelectorRenderer.swift
//  Accented
//
//  Created by Tiangong You on 6/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class ThemeSelectorRenderer: UICollectionViewCell {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var theme : AppTheme? {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let themeModel = theme {
            thumbnailView.image = themeModel.displayThumbnail
            titleLabel.text = themeModel.displayLabel
        }
    }
}
