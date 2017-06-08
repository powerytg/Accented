//
//  PearlFXViewController.swift
//  Accented
//
//  PearlFX is an advanced photo editor based on the awesome GPUImage project
//
//  Created by You, Tiangong on 6/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PearlFXViewController: UIViewController {

    // The original photo from camera
    private var originalImage : UIImage!
    
    // The preview photo
    private var previewImage : UIImage!
    
    // Preview image view
    private var previewView : InteractiveImageView!
    
    init(originalImage : UIImage, previewImage : UIImage) {
        self.originalImage = originalImage
        self.previewImage = previewImage
        super.init(nibName: "PearlFXViewController", bundle: nil)
        
        previewView = InteractiveImageView(image: self.previewImage, frame: UIScreen.main.bounds)
        view.addSubview(previewView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        previewView.frame = view.bounds
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        previewView.transitionToSize(size)
    }
}
