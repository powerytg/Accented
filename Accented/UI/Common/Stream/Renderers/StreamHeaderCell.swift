//
//  StreamHeaderCell.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class StreamHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleView: UIImageView!    
    @IBOutlet weak var streamSelectorView: StreamSelectorView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        streamSelectorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
