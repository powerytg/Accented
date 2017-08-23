//
//  FXSlider.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class FXSlider: UISlider {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.maximumTrackTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.46)
        self.minimumTrackTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.75)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var f = super.trackRect(forBounds: bounds)
        f.size.height = 16
        return f
    }

}
