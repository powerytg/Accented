//
//  ColorFilterViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class ColorFilterViewController: AdjustmentUIViewController {

    @IBOutlet weak var redSlider: FXSlider!
    @IBOutlet weak var greenSlider: FXSlider!
    @IBOutlet weak var blueSlider: FXSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redSlider.value = filterManager.red
        greenSlider.value = filterManager.green
        blueSlider.value = filterManager.blue
        
        redSlider.minimumTrackTintColor = UIColor(red: 240 / 255.0, green: 104 / 255.0, blue: 116 / 255.0, alpha: 0.75)
        greenSlider.minimumTrackTintColor = UIColor(red: 129 / 255.0, green: 227 / 255.0, blue: 136 / 255.0, alpha: 0.75)
        blueSlider.minimumTrackTintColor = UIColor(red: 95 / 255.0, green: 157 / 255.0, blue: 219 / 255.0, alpha: 0.75)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func redValueDidChange(_ sender: Any) {
        filterManager.red = redSlider.value
    }
    
    @IBAction func greenValueDidChange(_ sender: Any) {
        filterManager.green = greenSlider.value
    }
    
    @IBAction func blueValueDidChange(_ sender: Any) {
        filterManager.blue = blueSlider.value
    }
}
