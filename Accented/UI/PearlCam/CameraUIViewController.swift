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

protocol CameraOverlayDelegate : NSObjectProtocol {
    func switchCameraButtonDidTap()
    func shutterButtonDidTap()
    func didTapOnViewFinder(_ point : CGPoint)
    func didLongPressOnViewFinder(_ point : CGPoint)
    func userDidChangeExpComp(_ ec : Float)
    func userDidChangeShutterSpeed(_ shutterSpeed : CMTime)
    func userDidChangeISO(_ iso : Float)
    func userDidChangeFlashMode()
    func userDidUnlockAEL()
    func autoManualModeButtonDidTap()
}

class CameraUIViewController: UIViewController, MeterViewDelegate {

    @IBOutlet weak var expControlLabel: UILabel!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var exposureView: UIView!
    @IBOutlet weak var exposureIndicator: UIImageView!
    @IBOutlet weak var shutterSpeedLabel: UILabel!
    @IBOutlet weak var expControlView: UIStackView!
    @IBOutlet weak var isoLabel: UILabel!
    @IBOutlet weak var exposureIndicatorCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var lightMeterWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var exposureModeButton: UIButton!
    @IBOutlet weak var isoControlView: UIView!
    @IBOutlet weak var osdLabel: UILabel!
    @IBOutlet weak var aelButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    
    private var exposureIndicatorOffset : CGFloat = 2
    private var viewFinder : ViewFinder?
    
    var iso : Float?
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
    private var exposureMode : AVCaptureExposureMode?
    private let defaultISO : Float = 100
    private var currentShutterSpeed : CMTime?
    
    weak var delegate : CameraOverlayDelegate?
    
    // Current slider view
    var currentMeter : MeterType?
    private var currentMeterView : MeterView?
    private let meterViewHeight : CGFloat = 70
    private let exposureMeterScale : Float = 1000
    
    private var isLockingExposure = false
    
    // OSD text
    private var osdAttributes = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exposureView.layer.cornerRadius = 8
        
        osdAttributes = [NSStrokeColorAttributeName : UIColor.black,
                         NSStrokeWidthAttributeName : -1]
        
        osdLabel.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        osdLabel.layer.shadowRadius = 13.0
        osdLabel.layer.shadowOpacity = 0.85
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressOnViewFinder(_:)))
        viewFinder!.addGestureRecognizer(longPress)

        let expTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnExpControl(_:)))
        expControlView.addGestureRecognizer(expTap)
        
        let isoTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnISOControl(_:)))
        isoControlView.addGestureRecognizer(isoTap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // We always take the default, fixed 4/3 photo, so position the preview layer accordingly
        if let viewFinder = self.viewFinder {
            let aspectRatio = CGFloat(4.0 / 3.0)
            viewFinder.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height / aspectRatio)
        }
    }
    
    func showMessage(_ message : String) {
        let text = NSAttributedString(string: message.uppercased(), attributes: osdAttributes)
        osdLabel.attributedText = text
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.osdLabel.transform = CGAffineTransform(translationX: 0, y: -8)
            self?.osdLabel.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.3, delay: 2.0, options: .curveEaseInOut, animations: { [weak self] in
            self?.osdLabel.alpha = 0
            self?.osdLabel.transform = CGAffineTransform.identity
            }, completion: nil)
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
    
    func exposurePointDidChange(_ point : CGPoint) {
        if let viewFinder = viewFinder {
            viewFinder.aelPointDidChange(point)
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
        currentShutterSpeed = duration
        shutterSpeedLabel.text = formatExposureLabel(duration)
    }
    
    func isoReadingDidChange(_ iso : Float) {
        self.iso = iso
        let displayValue = Int(iso)
        isoLabel.text = "\(displayValue)"
    }
    
    func exposureModeDidChange(_ mode : AVCaptureExposureMode) {
        self.exposureMode = mode
        
        if mode == .autoExpose || mode == .continuousAutoExposure {
            exposureModeButton.setImage(UIImage(named: "AutoExpButton"), for: .normal)
            if !isLockingExposure {
                showMessage("AUTO MODE")
            }
            
            expControlLabel.text = formatExposureCompensationLabel(expComp)
        } else {
            exposureModeButton.setImage(UIImage(named: "ManualExpButton"), for: .normal)
            
            if !isLockingExposure {
                showMessage("MANUAL MODE")
            }
            
            expControlLabel.text = formatExposureLabel(currentShutterSpeed)
        }
    }
    
    func flashModeDidChange(_ mode: AVCaptureFlashMode) {
        switch mode {
        case .auto:
            flashButton.setImage(UIImage(named: "FlashAuto"), for: .normal)
        case .on:
            flashButton.setImage(UIImage(named: "FlashOn"), for: .normal)
        case .off:
            flashButton.setImage(UIImage(named: "FlashOff"), for: .normal)
        }
    }

    private func formatExposureLabel(_ exposure : CMTime?) -> String? {
        guard exposure != nil else { return nil }
        let shutterSpeed = Double(exposure!.value) / Double(exposure!.timescale)
        if shutterSpeed < 1.0 {
            let displayValue = Int(1.0 / shutterSpeed)
            return "1/\(displayValue)"
        } else {
            let displayValue = Int(shutterSpeed)
            return "\(displayValue)"
        }
    }
    
    private func formatExposureCompensationLabel(_ ec : Float?) -> String? {
        guard ec != nil else { return nil }
        if ec! >= 0 {
            return String(format: "+%.1f", ec!)
        } else {
            return String(format: "%.1f", ec!)
        }
    }
    
    private func fadeInMeterView(_ type : MeterType) {
        guard viewFinder != nil else { return }
        guard minExpComp != nil, maxExpComp != nil else { return }
        
        let meterOriginY : CGFloat = viewFinder!.bounds.maxY - meterViewHeight
        let f = CGRect(x: 0, y: meterOriginY, width: view.bounds.width, height: meterViewHeight)
        
        currentMeter = type
        switch type {
        case .exposureCompensation:
            currentMeterView = MeterView(meterType : .exposureCompensation, minValue: minExpComp!, maxValue: maxExpComp!, currentValue: expComp, frame: f)
        case .shutterSpeed:
            let minDisplayValue = Float(CMTimeGetSeconds(minShutterSpeed!)) * exposureMeterScale
            let maxDisplayValue = Float(CMTimeGetSeconds(maxShutterSpeed!)) * exposureMeterScale
            let currentDisplayValue = Float(CMTimeGetSeconds(currentShutterSpeed!)) * exposureMeterScale
            currentMeterView = MeterView(meterType : .shutterSpeed, minValue: minDisplayValue, maxValue: maxDisplayValue, currentValue: currentDisplayValue, frame: f)
        case .iso:
            let currentISO = (iso != nil ? iso! : defaultISO)
            currentMeterView = MeterView(meterType : .iso, minValue: minISO!, maxValue: maxISO!, currentValue: currentISO, frame: f)
        }
        
        currentMeterView!.delegate = self
        view.addSubview(currentMeterView!)
        currentMeterView!.isHidden = false
        currentMeterView!.alpha = 0
        currentMeterView!.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.currentMeterView?.alpha = 1
            self?.currentMeterView?.transform = CGAffineTransform.identity
        }
    }
    
    private func fadeOutMeterView() {
        guard minExpComp != nil, maxExpComp != nil else { return }
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.currentMeterView?.alpha = 0
            self?.currentMeterView?.transform = CGAffineTransform(translationX: 0, y: 20)
        }) { [weak self] (finished) in
            self?.currentMeterView?.isHidden = true
        }
    }
    
    private func showAELButton() {
        aelButton.alpha = 0
        aelButton.isHidden = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.aelButton.alpha = 1
        }
    }
    
    private func hideAELButton() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.aelButton.alpha = 0
        }) { [weak self] (finished) in
            self?.aelButton.isHidden = true
        }
    }
    
    @IBAction func switchCameraButtonDidTap(_ sender: Any) {
        delegate?.switchCameraButtonDidTap()
    }

    @IBAction func shutterButtonDidTap(_ sender: Any) {
        if currentMeterView != nil && !currentMeterView!.isHidden {
            fadeOutMeterView()
        }

        delegate?.shutterButtonDidTap()
    }

    @IBAction func autoManualButtonDidTap(_ sender: Any) {
        if currentMeterView != nil && !currentMeterView!.isHidden {
            fadeOutMeterView()
        }

        // Do not switch mode if either auto or manual mode being not supported
        guard isAutoExpModeSupported != nil && isManualExpModeSupported != nil else { return }
        guard isAutoExpModeSupported! && isManualExpModeSupported! else { return }
        delegate?.autoManualModeButtonDidTap()
    }
    
    // MARK: - MeterViewDelegate
    
    func meterValueDidChange(_ value: Float) {
        guard currentMeter != nil else { return }
        
        if let meterType = currentMeter {
            switch meterType {
            case .exposureCompensation:
                guard minExpComp != nil && maxExpComp != nil else { return }
                guard value >= minExpComp! && value <= maxExpComp! else { return }
                expComp = value
                expControlLabel.text = formatExposureCompensationLabel(expComp)
                delegate?.userDidChangeExpComp(value)
            case .iso:
                guard minISO != nil && maxISO != nil else { return }
                guard value >= minISO! && value <= maxISO! else { return }
                iso = value
                let displayValue = Int(iso!)
                isoLabel.text = "\(displayValue)"
                delegate?.userDidChangeISO(iso!)
            case .shutterSpeed:
                let exp = CMTime(seconds: Double(value / exposureMeterScale), preferredTimescale: currentShutterSpeed!.timescale)
                guard minShutterSpeed != nil && maxShutterSpeed != nil else { return }
                guard exp >= minShutterSpeed! && exp <= maxShutterSpeed! else { return }
                currentShutterSpeed = exp
                expControlLabel.text = formatExposureLabel(currentShutterSpeed)
                delegate?.userDidChangeShutterSpeed(exp)
            }
        }
    }
    
    // MARK: - Gestures
    
    @objc private func didTapOnViewFinder(_ tap : UITapGestureRecognizer) {
        if currentMeterView != nil && !currentMeterView!.isHidden {
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
    
    @objc private func didLongPressOnViewFinder(_ tap : UILongPressGestureRecognizer) {
        if currentMeterView != nil && !currentMeterView!.isHidden {
            fadeOutMeterView()
            return
        }

        switch tap.state {
        case .began:
            isLockingExposure = true
            let positionInView = tap.location(in: viewFinder)
            let positionInCamera = viewFinder?.previewLayer.captureDevicePointOfInterest(for: positionInView)
            if let pt = positionInCamera {
                debugPrint("AEL set to \(pt)")
                delegate?.didLongPressOnViewFinder(pt)
            }

            viewFinder?.aelDidLock()
            showAELButton()
        case .ended:
            isLockingExposure = false            
            showMessage("AUTO EXP LOCKED")
        case .cancelled:
            isLockingExposure = false
        default:
            break
        }
    }
    
    @objc private func didTapOnExpControl(_ tap : UITapGestureRecognizer) {
        if currentMeterView != nil && !currentMeterView!.isHidden {
            fadeOutMeterView()
            return
        } else {
            if exposureMode == nil || exposureMode! == .autoExpose || exposureMode! == .continuousAutoExposure {
                fadeInMeterView(.exposureCompensation)
            } else {
                guard minShutterSpeed != nil, maxShutterSpeed != nil, currentShutterSpeed != nil else { return }
                fadeInMeterView(.shutterSpeed)
            }
        }
    }
    
    @objc private func didTapOnISOControl(_ tap : UITapGestureRecognizer) {
        if isManualExpModeSupported == nil || !isManualExpModeSupported! {
            return
        }
        
        if currentMeterView != nil && !currentMeterView!.isHidden {
            fadeOutMeterView()
            return
        } else {
            // We need to set the camera exposure mode to manual so that we can set fixed iso
            if exposureMode == nil || exposureMode! == .autoExpose || exposureMode! == .continuousAutoExposure {
                delegate?.autoManualModeButtonDidTap()
            }
            
            fadeInMeterView(.iso)
        }
    }
    
    @IBAction func didTapOnAELButton(_ sender: Any) {
        delegate?.userDidUnlockAEL()
        hideAELButton()
        viewFinder?.aelDidUnlock()
    }
    
    @IBAction func didTapOnFlashButton(_ sender: Any) {
        delegate?.userDidChangeFlashMode()
    }
}
