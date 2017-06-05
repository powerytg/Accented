//
//  CameraUIViewController.swift
//  Accented
//
//  PearlCam camera UI overlay controller
//
//  Created by Tiangong You on 6/3/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol CameraOverlayDelegate : NSObjectProtocol {
    func switchCameraButtonDidTap()
    func shutterButtonDidTap()
}

class CameraUIViewController: UIViewController {

    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var shutterButton: UIButton!
    
    weak var delegate : CameraOverlayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchCameraButtonDidTap(_ sender: Any) {
        delegate?.switchCameraButtonDidTap()
    }

    @IBAction func shutterButtonDidTap(_ sender: Any) {
        delegate?.shutterButtonDidTap()
    }
}
