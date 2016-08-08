//
//  CardViewController.swift
//  Accented
//
//  Created by You, Tiangong on 8/5/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, CardAnimation {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareForReuse() {
        // Not implemented in base class
    }

    // MARK : - Animation
    
    func cardDidReceivePanGesture(translation: CGFloat, cardWidth: CGFloat) {
        // Not implemented in base class
    }
    
    func cardSelectionDidChange(selected: Bool) {
        // Not implemented in base class
    }
    
    func performCardTransitionAnimation() {
        // Not implemented in base class
    }
}
