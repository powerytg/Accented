//
//  MonochromeFilterViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MonochromeFilterViewController: AdjustmentUIViewController {

    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var intensitySlider: FXSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enabledSwitch.isOn = filterManager.enableMonochrome
        intensitySlider.value = filterManager.monochromeIntensity
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func intensityValueDidChange(_ sender: Any) {
        filterManager.monochromeIntensity = intensitySlider.value
    }
    
    @IBAction func enabledStateDidChange(_ sender: Any) {
        filterManager.enableMonochrome = enabledSwitch.isOn
        intensitySlider.isEnabled = enabledSwitch.isOn
    }
}
