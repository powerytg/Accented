//
//  PushButton.swift
//  Accented
//
//  Created by You, Tiangong on 5/4/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class PushButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.1)
        
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
    }

}
