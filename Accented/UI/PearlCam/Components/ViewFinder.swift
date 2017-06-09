//
//  ViewFinder.swift
//  Accented
//
//  Viewfinder provides a camera preview in addition of allowing selecting focus points
//
//  Created by Tiangong You on 6/7/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import AVFoundation

class ViewFinder: UIView {
    
    private let focusIndicatorSize : CGFloat = 30
    private var focusIndicator = UIView()
    var previewLayer : AVCaptureVideoPreviewLayer
    
    init(previewLayer : AVCaptureVideoPreviewLayer, frame: CGRect) {
        self.previewLayer = previewLayer
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        layer.addSublayer(previewLayer)
        
        focusIndicator.frame = CGRect(x: 0, y: 0, width: focusIndicatorSize, height: focusIndicatorSize)
        focusIndicator.layer.borderWidth = 2
        focusIndicator.layer.borderColor = UIColor(red: 0, green: 222 / 255.0, blue: 136 / 255.0, alpha: 1).cgColor
        focusIndicator.alpha = 0
        addSubview(focusIndicator)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        previewLayer.frame = self.bounds
    }
    
    func focusPointDidChange(_ point : CGPoint) {
        let coord = previewLayer.pointForCaptureDevicePoint(ofInterest: point)
        
        focusIndicator.frame.origin.x = coord.x
        focusIndicator.frame.origin.y = coord.y
    }
    
    func focusDidStart() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.repeat, .autoreverse], animations: { [weak self] in
            self?.focusIndicator.alpha = 1
        }, completion: nil)
    }
    
    func focusDidStop() {
        focusIndicator.layer.removeAllAnimations()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.focusIndicator.alpha = 0
            })
        }
    }
}
