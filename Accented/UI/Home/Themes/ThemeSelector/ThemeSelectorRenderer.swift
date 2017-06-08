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
        
        thumbnailView.layer.shadowOffset = CGSize(width: 0, height: 1);
        thumbnailView.layer.shadowRadius = 3;
        thumbnailView.layer.borderColor = UIColor(red: 30 / 255.0, green: 128 / 255.0, blue: 243 / 255.0, alpha: 1.0).cgColor
        thumbnailView.layer.shadowPath = UIBezierPath(rect: self.thumbnailView.bounds).cgPath
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let themeModel = theme {
            thumbnailView.image = themeModel.displayThumbnail
            titleLabel.text = themeModel.displayLabel
        }
        
        if self.isSelected {
            self.applySelectedState()
        } else {
            self.applyUnselectedState()
        }
    }
    
    private func applyUnselectedState() {
        thumbnailView.layer.masksToBounds = false;
        thumbnailView.layer.shadowOpacity = 0.9;
        thumbnailView.layer.cornerRadius = 0;
        thumbnailView.layer.borderWidth = 0;
    }
    
    private func applySelectedState() {
        thumbnailView.layer.masksToBounds = true;
        thumbnailView.layer.cornerRadius = 4;
        thumbnailView.layer.borderWidth = 4;
        thumbnailView.layer.shadowOpacity = 0;
    }
    
}
