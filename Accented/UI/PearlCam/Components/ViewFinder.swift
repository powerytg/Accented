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
    private let aelIndicatorSize : CGFloat = 60
    private var focusIndicator = UIView()
    private var aelIndicator = UIView()
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

        aelIndicator.frame = CGRect(x: 0, y: 0, width: aelIndicatorSize, height: aelIndicatorSize)
        aelIndicator.layer.borderWidth = 2
        aelIndicator.layer.borderColor = UIColor(red: 247 / 255.0, green: 248 / 255.0, blue: 141 / 255.0, alpha: 1).cgColor
        aelIndicator.alpha = 0
        addSubview(aelIndicator)
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
    
    func aelPointDidChange(_ point : CGPoint) {
        let coord = previewLayer.pointForCaptureDevicePoint(ofInterest: point)
        
        aelIndicator.frame.origin.x = coord.x
        aelIndicator.frame.origin.y = coord.y
    }
    
    func aelDidLock() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.aelIndicator.alpha = 1
        }, completion: nil)
    }
    
    func aelDidUnlock() {
        aelIndicator.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.aelIndicator.alpha = 0
        })
    }
}
