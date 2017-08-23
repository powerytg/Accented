//
//  VignetteFilterViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class VignetteFilterViewController: AdjustmentUIViewController {

    @IBOutlet weak var enabledSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enabledSwitch.isOn = filterManager.enableVignette
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func enabledValueDidChange(_ sender: Any) {
        filterManager.enableVignette = enabledSwitch.isOn
    }
}
