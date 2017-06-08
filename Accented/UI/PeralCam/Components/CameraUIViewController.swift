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
import CRRulerControl

enum MeterType {
    case exposureCompensation
    case iso
    case shutterSpeed
}

protocol CameraOverlayDelegate : NSObjectProtocol {
    func switchCameraButtonDidTap()
    func shutterButtonDidTap()
    func didTapOnViewFinder(_ point : CGPoint)
    func userDidChangeExpComp(_ ec : Float)
}

class CameraUIViewController: UIViewController {

    @IBOutlet weak var expControlLabel: UILabel!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var exposureView: UIView!
    @IBOutlet weak var exposureIndicator: UIImageView!
    @IBOutlet weak var shutterSpeedLabel: UILabel!
    @IBOutlet weak var expControlView: UIStackView!
    @IBOutlet weak var isoLabel: UILabel!
    @IBOutlet weak var rulerView: CRRulerControl!
    @IBOutlet weak var rulerContainerView: UIView!
    @IBOutlet weak var rulerContainerBottomConstraint: NSLayoutConstraint!
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
    var expComp : Float = 0
    
    var currentMeter : MeterType?
    
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
        
        let expTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnExpControl(_:)))
        expControlView.addGestureRecognizer(expTap)
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
        let value = CGFloat(offset + expComp)
        let lightMeterWidth = lightMeterWidthConstraint.constant
        let step = lightMeterWidth / 18.0
        var position : CGFloat = value * step
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
    
    private func fadeInMeterView(_ type : MeterType) {
        guard viewFinder != nil else { return }
        guard minExpComp != nil, maxExpComp != nil else { return }
        
        rulerContainerBottomConstraint.constant = view.bounds.maxY - viewFinder!.bounds.maxY
        
        currentMeter = type
        if type == .exposureCompensation {
            initializeExpCompSlider()
        }
        
        rulerContainerView.isHidden = false
        rulerContainerView.alpha = 0
        rulerContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.rulerContainerView.alpha = 1
            self?.rulerContainerView.transform = CGAffineTransform.identity
        }
    }
    
    private func fadeOutMeterView() {
        guard minExpComp != nil, maxExpComp != nil else { return }
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.rulerContainerView.alpha = 0
            self?.rulerContainerView.transform = CGAffineTransform(translationX: 0, y: 60)
        }) { [weak self] (finished) in
            self?.rulerContainerView.isHidden = true
        }
    }
    
    private func initializeExpCompSlider() {
        rulerView.rulerWidth = view.bounds.width * 1.4
        rulerView.rangeFrom = CGFloat(minExpComp!)
        rulerView.rangeLength = CGFloat(maxExpComp! - minExpComp!)
        rulerView.spacingBetweenMarks = 30
        rulerView.setValue(CGFloat(expComp), animated: false)
        
        rulerView.setNeedsLayout()
    }
    
    @IBAction func switchCameraButtonDidTap(_ sender: Any) {
        delegate?.switchCameraButtonDidTap()
    }

    @IBAction func shutterButtonDidTap(_ sender: Any) {
        delegate?.shutterButtonDidTap()
    }

    @IBAction func rulerValueChanged(_ sender: Any) {
        guard currentMeter != nil else { return }
        let ruler = sender as! CRRulerControl
        
        if let meterType = currentMeter {
            if meterType == .exposureCompensation {
                expComp = Float(ruler.value)
                if expComp >= 0 {
                    expControlLabel.text = String(format: "+%.1f", expComp)
                } else {
                    expControlLabel.text = String(format: "%.1f", expComp)
                }
                
                delegate?.userDidChangeExpComp(Float(ruler.value))
            }
        }
    }
    
    // MARK: - Gestures
    
    @objc private func didTapOnViewFinder(_ tap : UITapGestureRecognizer) {
        if !rulerContainerView.isHidden {
            fadeOutMeterView()
            return
        }
        
        let positionInView = tap.location(in: viewFinder)
        let positionInCamera = viewFinder?.previewLayer.captureDevicePointOfInterest(for: positionInView)
        if let pt = positionInCamera {
            debugPrint("Focus point changed to \(pt)")
            delegate?.didTapOnViewFinder(pt)
        }
    }
    
    @objc private func didTapOnExpControl(_ tap : UITapGestureRecognizer) {
        if !rulerContainerView.isHidden {
            fadeOutMeterView()
            return
        } else {
            fadeInMeterView(.exposureCompensation)
        }
    }
}
