//
//  StreamHeaderNavCell.swift
//  Accented
//
//  Created by Tiangong You on 5/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DefaultStreamHeaderNavCell: UICollectionViewCell {

    @IBOutlet weak var blurView: DefaultNavBlurView!
    @IBOutlet weak var streamSelectorView: DefaultStreamSelectorView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    private let lightThemeImage = UIImage(named: "LightStreamHeader")
    private let darkThemeImage = UIImage(named: "DarkStreamHeader")
    
    var compressionRatio : CGFloat = 0
    
    var navBarDefaultPosition : CGFloat {
        return streamSelectorView.frame.minY - UIApplication.shared.statusBarFrame.height
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch ThemeManager.sharedInstance.currentTheme.themeType {
        case .light:
            headerImageView.image = lightThemeImage
        default:
            headerImageView.image = darkThemeImage
        }
        
        headerImageView.alpha = 1 - compressionRatio
        blurView.alpha = compressionRatio
        blurView.setNeedsLayout()
        
        streamSelectorView.compressionRateio = compressionRatio
        streamSelectorView.setNeedsLayout()
    }
}
