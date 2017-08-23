//
//  BrightnessFilterViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class BrightnessFilterViewController: AdjustmentUIViewController {

    @IBOutlet weak var brightnessSlider: FXSlider!
    @IBOutlet weak var contrastSlider: FXSlider!
    @IBOutlet weak var vibranceSlider: FXSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brightnessSlider.value = filterManager.exposure!
        contrastSlider.value = filterManager.contrast!
        vibranceSlider.value = filterManager.vibrance!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func brightnessValueDidChange(_ sender: Any) {
        filterManager.exposure = brightnessSlider.value
    }
    
    @IBAction func contrastValueDidChange(_ sender: Any) {
        filterManager.contrast = contrastSlider.value
    }
    
    @IBAction func vibranceValueDidChange(_ sender: Any) {
        filterManager.vibrance = vibranceSlider.value
    }
}
