//
//  JournalBackdropCell.swift
//  Accented
//
//  Created by Tiangong You on 5/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class JournalBackdropCell: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
