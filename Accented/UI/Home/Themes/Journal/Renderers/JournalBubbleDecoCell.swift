//
//  JournalBubbleDecoCell.swift
//  Accented
//
//  Created by Tiangong You on 5/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalBubbleDecoCell: UICollectionReusableView {
    var imageView = UIImageView(image: UIImage(named : "DarkJournalBubble"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
