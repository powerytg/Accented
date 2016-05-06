//
//  StreamHeaderNavCell.swift
//  Accented
//
//  Created by Tiangong You on 5/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamHeaderNavCell: UICollectionViewCell {

    @IBOutlet weak var blurView: BlurView!
    @IBOutlet weak var streamSelectorView: StreamSelectorView!
    
    var compressionRatio : CGFloat = 0
    
    var navBarDefaultPosition : CGFloat {
        return CGRectGetMinY(streamSelectorView.frame) - CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurView.alpha = compressionRatio
        
        streamSelectorView.compressionRateio = compressionRatio
        streamSelectorView.setNeedsLayout()
    }
}
