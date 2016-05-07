//
//  StreamHeaderNavCell.swift
//  Accented
//
//  Created by Tiangong You on 5/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamHeaderNavCell: UICollectionViewCell {

    @IBOutlet weak var blurView: GatewayNavBlurView!
    @IBOutlet weak var streamSelectorView: StreamSelectorView!
    @IBOutlet weak var headerImageView: UIImageView!
    
    private let lightThemeImage = UIImage(named: "LightStreamHeader")
    private let darkThemeImage = UIImage(named: "DarkStreamHeader")
    
    var compressionRatio : CGFloat = 0
    
    var navBarDefaultPosition : CGFloat {
        return CGRectGetMinY(streamSelectorView.frame) - CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch ThemeManager.sharedInstance.currentTheme.themeType {
        case .Light:
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
