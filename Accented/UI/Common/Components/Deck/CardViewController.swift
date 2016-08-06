//
//  CardViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    var label : UILabel = UILabel()
    
    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareForReuse() {
        // Base class do nothing
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.label.text = String(index)
        label.sizeToFit()
        
        var f = label.frame
        f.origin.x = 50
        f.origin.y = 50
        label.frame = f
    }
    
}
