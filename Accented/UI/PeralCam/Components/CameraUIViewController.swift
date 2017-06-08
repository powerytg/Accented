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
import AVFoundation

protocol CameraOverlayDelegate : NSObjectProtocol {
    func switchCameraButtonDidTap()
    func shutterButtonDidTap()
    func didTapOnViewFinder(_ point : CGPoint)
}

class CameraUIViewController: UIViewController {

    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var exposureView: UIView!
    @IBOutlet weak var exposureIndicator: UIImageView!
    @IBOutlet weak var shutterSpeedLabel: UILabel!
    @IBOutlet weak var expControlView: UIStackView!
    @IBOutlet weak var isoLabel: UILabel!
    
    @IBOutlet weak var exposureIndicatorCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var lightMeterWidthConstraint: NSLayoutConstraint!
    
    private var exposureIndicatorOffset : CGFloat = 2
    private var viewFinder : ViewFinder?
    
    var minISO : Float?
    var maxISO : Float?
    var maxZoomFactor : CGFloat?
    var minShutterSpeed : CMTime?
    var maxShutterSpeed : CMTime?
    var minExpComp : Float?
    var maxExpComp : Float?
    var isManualExpModeSupported : Bool?
    var isAutoExpModeSupported : Bool?
    var isContinuousAutoExpModeSupported : Bool?
    
    weak var delegate : CameraOverlayDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exposureView.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func previewDidBecomeAvailable(previewLayer : AVCaptureVideoPreviewLayer) {
        if viewFinder != nil && viewFinder?.previewLayer == previewLayer {
            return
        }
        
        if let viewFinder = self.viewFinder {
            viewFinder.removeFromSuperview()
        }
        
        viewFinder = ViewFinder(previewLayer: previewLayer, frame: view.bounds)
        view.insertSubview(viewFinder!, at: 0)
        
        // Events
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnViewFinder(_:)))
        viewFinder!.addGestureRecognizer(tap)
        
        let expGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragOnExpControl(_:)))
        expControlView.addGestureRecognizer(expGesture)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        
        // We always take the default, fixed 4/3 photo, so position the preview layer accordingly
        if let viewFinder = self.viewFinder {
            let aspectRatio = CGFloat(4.0 / 3.0)
            viewFinder.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / aspectRatio)
        }
    }
    
    func focusPointDidChange(_ point: CGPoint) {
        if let viewFinder = viewFinder {
            viewFinder.focusPointDidChange(point)
        }
    }
    
    func focusDidStart(){
        if let viewFinder = viewFinder {
            viewFinder.focusDidStart()
        }
    }
    
    func focusDidStop() {
        if let viewFinder = viewFinder {
            viewFinder.focusDidStop()
        }
    }
    
    func lightMeterReadingDidChange(_ offset: Float) {
        let lightMeterWidth = lightMeterWidthConstraint.constant
        let step = lightMeterWidth / 18.0
        var position : CGFloat = CGFloat(offset) / step
        position = max(min(position, lightMeterWidth / 2), -lightMeterWidth / 2)
        exposureIndicatorCenterConstraint.constant = position + exposureIndicatorOffset
    }
    
    func shutterSpeedReadingDidChange(_ duration: CMTime) {
        let shutterSpeed = Double(duration.value) / Double(duration.timescale)
        if shutterSpeed < 1.0 {
            let displayValue = Int(1.0 / shutterSpeed)
            shutterSpeedLabel.text = "1/\(displayValue)"
        } else {
            let displayValue = Int(shutterSpeed)
            shutterSpeedLabel.text = "\(displayValue)"
        }
        
    }
    
    func isoReadingDidChange(_ iso : Float) {
        let displayValue = Int(iso)
        isoLabel.text = "\(displayValue)"
    }
    
    @IBAction func switchCameraButtonDidTap(_ sender: Any) {
        delegate?.switchCameraButtonDidTap()
    }

    @IBAction func shutterButtonDidTap(_ sender: Any) {
        delegate?.shutterButtonDidTap()
    }
    
    @objc private func didTapOnViewFinder(_ tap : UITapGestureRecognizer) {
        let positionInView = tap.location(in: viewFinder)
        let positionInCamera = viewFinder?.previewLayer.captureDevicePointOfInterest(for: positionInView)
        if let pt = positionInCamera {
            debugPrint("Focus point changed to \(pt)")
            delegate?.didTapOnViewFinder(pt)
        }
    }
    
    // MARK: - Gestures
    
    @objc private func didDragOnExpControl(_ swipe : UIPanGestureRecognizer) {
        switch swipe.state {
        case .began:
            break
        default:
            break
        }
    }
}
