//
//  WhiteBalanceFilterViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class WhiteBalanceFilterViewController: AdjustmentUIViewController {

    @IBOutlet weak var tempSlider: FXSlider!
    @IBOutlet weak var tintSlider: FXSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempSlider.value = filterManager.temperature
        tintSlider.value = filterManager.tint
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tempValueDidChange(_ sender: Any) {
        filterManager.temperature = tempSlider.value
    }
    
    @IBAction func tintValueDidChange(_ sender: Any) {
        filterManager.tint = tintSlider.value
    }
}
