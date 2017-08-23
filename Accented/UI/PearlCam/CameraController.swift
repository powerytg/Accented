//
//  CameraController.swift
//  Accented
//
//  Created by Tiangong You on 6/3/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraDelegate : NSObjectProtocol {
    func previewLayerBecomeAvailable(_ previewLayer : AVCaptureVideoPreviewLayer)
    func onFatalError(errorMessage : String)
    func didCapturePhoto(data : Data)
    func focusPointDidChange(_ point : CGPoint)
    func exposurePointDidChange(_ point : CGPoint)
    func focusDidStart()
    func focusDidStop()
    func lightMeterReadingDidChange(_ offset : Float)
    func shutterSpeedReadingDidChange(_ duration : CMTime)
    func isoReadingDidChange(_ iso : Float)
    func exposureModeDidChange(_ mode : AVCaptureExposureMode)
    func flashModeDidChange(_ mode : AVCaptureFlashMode)
}

class CameraController: NSObject, AVCapturePhotoCaptureDelegate {
    private var captureSession = AVCaptureSession()
    private var capturePhotoOutput : AVCapturePhotoOutput!
    private var photoSettings : AVCapturePhotoSettings?
    private let sessionQueue = DispatchQueue.global(qos: .default)
    var isInitialized = false
    
    @objc private var currentCamera : AVCaptureDevice?
    private var frontCamera : AVCaptureDevice?
    private var backCamera : AVCaptureDevice?
    
    var cameraPosition : AVCaptureDevicePosition
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    
    var context = CIContext()

    var exposureMode : AVCaptureExposureMode? {
        return currentCamera?.exposureMode
    }
    
    var minISO : Float? {
        return currentCamera?.activeFormat.minISO
    }

    var maxISO : Float? {
        return currentCamera?.activeFormat.maxISO
    }
    
    var maxZoomFactor : CGFloat? {
        return currentCamera?.activeFormat.videoMaxZoomFactor
    }
    
    var minShutterSpeed : CMTime? {
        return currentCamera?.activeFormat.minExposureDuration
    }
    
    var maxShutterSpeed : CMTime? {
        return currentCamera?.activeFormat.maxExposureDuration
    }
    
    var minExpComp : Float? {
        return currentCamera?.minExposureTargetBias
    }
    
    var maxExpComp : Float? {
        return currentCamera?.maxExposureTargetBias
    }
    
    var isManualExpModeSupported : Bool? {
        return currentCamera?.isExposureModeSupported(.custom)
    }
    
    var isAutoExpModeSupported : Bool? {
        return currentCamera?.isExposureModeSupported(.autoExpose)
    }

    var isContinuousAutoExpModeSupported : Bool? {
        return currentCamera?.isExposureModeSupported(.continuousAutoExposure)
    }

    var supportedFlashModes : [AVCaptureFlashMode]?
    private var currentFlashMode : AVCaptureFlashMode?
    
    var flashSupported : Bool? {
        return currentCamera?.hasFlash
    }
    
    weak var delegate : CameraDelegate?
    
    init(position : AVCaptureDevicePosition) {
        cameraPosition = position
        super.init()

        // Create a photo settings
        createNewPhotoSettings()
        
        // Check for available cameras
        initializeDeviceSupport()
    }
    
    deinit {
        if currentCamera != nil {
            removeCameraObservers()
        }
        
        currentCamera = nil
    }
    
    static func hasFrontCamera() -> Bool {
        return (AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) != nil)
    }
    
    static func hasBackCamera() -> Bool {
        return (AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) != nil)
    }
    
    private func initializeDeviceSupport() {
        frontCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        backCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
    }
    
    private var orientationMap: [UIDeviceOrientation : AVCaptureVideoOrientation] = [
        .portrait           : .portrait,
        .portraitUpsideDown : .portraitUpsideDown,
        .landscapeLeft      : .landscapeRight,
        .landscapeRight     : .landscapeLeft,
        .faceUp             : .portrait,
        .faceDown           : .portraitUpsideDown
        ]
    
    func isCameraAvailable(_ position : AVCaptureDevicePosition) -> Bool {
        if position == .front {
            return (frontCamera != nil)
        } else {
            return (backCamera != nil)
        }
    }
    
    func initializeCamera(_ completionHandler: ((_ success: Bool) -> Void)) {
        var success = false
        defer { completionHandler(success) }
        
        let device = (cameraPosition == .front ? frontCamera : backCamera)
        guard device != nil else {
            success = false
            debugPrint("No camera available at position \(cameraPosition)")
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: device!) else {
            debugPrint("Unable to obtain video input for default camera.")
            return
        }
        
        if currentCamera == device {
            success = true
            return
        } else {
            // Remove observers on the previous camera
            removeCameraObservers()
        }
        
        // Config photo output
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        capturePhotoOutput.isLivePhotoCaptureEnabled = capturePhotoOutput.isLivePhotoCaptureSupported
        
        guard self.captureSession.canAddInput(videoInput) else {
            debugPrint("AVCaptureSession cannot add input")
            return
        }
        guard self.captureSession.canAddOutput(capturePhotoOutput) else {
            debugPrint("AVCaptureSession cannot add output")
            return
        }
        
        // Start a new session
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
        
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        captureSession.addInput(videoInput)
        captureSession.addOutput(capturePhotoOutput)
        captureSession.commitConfiguration()
        
        // Create a preview layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.backgroundColor = UIColor.black.cgColor
        delegate?.previewLayerBecomeAvailable(previewLayer)
        
        // Initialize flash modes (only for the first time)
        if supportedFlashModes == nil {
            supportedFlashModes = []
            for flashMode in [AVCaptureFlashMode.off, AVCaptureFlashMode.on, AVCaptureFlashMode.auto] {
                if capturePhotoOutput.supportedFlashModes.contains(NSNumber(value: flashMode.rawValue)) {
                    supportedFlashModes?.append(flashMode)
                    
                    if flashMode == .auto {
                        currentFlashMode = .auto
                    }
                }
            }            
        }
        
        currentCamera = device
        isInitialized = true
        success = true

        // Observing key property changes in the camera
        addCameraObservers()
    }
    
    private func addCameraObservers() {
        if let camera = currentCamera {
            camera.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.focusPointOfInterest), options: [.old, .new], context: nil)
            camera.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.isAdjustingFocus), options: [.old, .new], context: nil)
            camera.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureTargetOffset), options: [.old, .new], context: nil)
            camera.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureDuration), options: [.old, .new], context: nil)
            camera.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.iso), options: [.old, .new], context: nil)
            camera.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureMode), options: [.old, .new], context: nil)
            camera.addObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposurePointOfInterest), options: [.old, .new], context: nil)
        }
    }
    
    private func removeCameraObservers() {
        if let camera = currentCamera {
            camera.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.focusPointOfInterest))
            camera.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.isAdjustingFocus))
            camera.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureTargetOffset))
            camera.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureDuration))
            camera.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.iso))
            camera.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposureMode))
            camera.removeObserver(self, forKeyPath: #keyPath(AVCaptureDevice.exposurePointOfInterest))
        }
    }
    
    func updateVideoOrientationForDeviceOrientation() {
        if let videoPreviewLayerConnection = previewLayer.connection {
            let deviceOrientation = UIDevice.current.orientation
            guard let newVideoOrientation = orientationMap[deviceOrientation],
                deviceOrientation.isPortrait || deviceOrientation.isLandscape
                else { return }
            videoPreviewLayerConnection.videoOrientation = newVideoOrientation
        }
    }
    
    func start() {
        guard isInitialized else { return }
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    func stop() {
        guard isInitialized else { return }
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    func focusToPoint(_ point : CGPoint) {
        if let camera = currentCamera {
            if !camera.isFocusPointOfInterestSupported || !camera.isFocusModeSupported(.autoFocus) {
                debugPrint("Camera \(camera.position) does not support setting focus point or auto focus mode")
                return
            }
            
            do {
                try camera.lockForConfiguration()
                camera.focusMode = .autoFocus
                camera.focusPointOfInterest = point
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to set focus point: \(error)")
            }
        }
    }
    
    func lockExposureToPoint(_ point : CGPoint) {
        if let camera = currentCamera {
            if !camera.isExposurePointOfInterestSupported || !camera.isExposureModeSupported(.continuousAutoExposure) || !camera.isExposureModeSupported(.autoExpose) {
                debugPrint("Camera \(camera.position) does not support settings exposure point, or does not support auto exposure mode")
                return
            }
            
            do {
                try camera.lockForConfiguration()
                camera.exposurePointOfInterest = point
                if camera.isExposureModeSupported(.continuousAutoExposure) {
                    camera.exposureMode = .continuousAutoExposure
                } else if camera.isExposureModeSupported(.autoExpose) {
                    camera.exposureMode = .autoExpose
                }
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to set focus point: \(error)")
            }
        }
    }
    
    func setExposureCompensation(_ ec : Float) {
        if let camera = currentCamera {
            do {
                try camera.lockForConfiguration()
                camera.setExposureTargetBias(ec, completionHandler: nil)
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to set exposure compensation: \(error)")
            }
        }
    }
    
    func setISO(_ iso : Float) {
        if let camera = currentCamera {
            guard camera.isExposureModeSupported(.custom) else { return }
            guard camera.exposureMode == .custom else { return }
            do {
                try camera.lockForConfiguration()
                camera.setExposureModeCustomWithDuration(camera.exposureDuration, iso: iso, completionHandler: nil)
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to set iso: \(error)")
            }
        }
    }
    
    func setExposure(_ exposure : CMTime) {
        if let camera = currentCamera {
            guard camera.isExposureModeSupported(.custom) else { return }
            guard camera.exposureMode == .custom else { return }
            do {
                try camera.lockForConfiguration()
                camera.setExposureModeCustomWithDuration(exposure, iso: camera.iso, completionHandler: nil)
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to set shutter speed: \(error)")
            }
        }
    }
    
    func switchToAutoExposureMode() {
        if let camera = currentCamera {
            guard camera.isExposureModeSupported(.continuousAutoExposure) || camera.isExposureModeSupported(.autoExpose) else { return }
            guard camera.exposureMode != .autoExpose && camera.exposureMode != .continuousAutoExposure else { return }
            do {
                try camera.lockForConfiguration()
                if camera.isExposureModeSupported(.continuousAutoExposure) {
                    camera.exposureMode = .continuousAutoExposure
                } else if camera.isExposureModeSupported(.autoExpose) {
                    camera.exposureMode = .autoExpose
                }
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to set exposure compensation: \(error)")
            }
        }
    }
    
    func switchToManualExposureMode() {
        if let camera = currentCamera {
            guard camera.exposureMode != .custom else { return }
            do {
                try camera.lockForConfiguration()
                camera.setExposureModeCustomWithDuration(camera.exposureDuration, iso: camera.iso, completionHandler: nil)
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to set exposure compensation: \(error)")
            }
        }
    }
    
    func switchToNextAvailableFlashMode() {
        guard supportedFlashModes != nil else { return }
        guard photoSettings != nil else { return }
        
        let currentFlashModeIndex = supportedFlashModes?.index(of: currentFlashMode!)
        guard currentFlashModeIndex != nil else { return }
        var nextIndex = currentFlashModeIndex!
        if currentFlashModeIndex == 0 {
            nextIndex = 1
        } else if currentFlashModeIndex == supportedFlashModes!.count - 1 {
            nextIndex = 0
        } else {
            nextIndex += 1
        }
        
        currentFlashMode = supportedFlashModes![nextIndex]
        photoSettings!.flashMode = currentFlashMode!
        delegate?.flashModeDidChange(currentFlashMode!)
    }
    
    func unlockAEL() {
        if let camera = currentCamera {
            guard camera.isExposureModeSupported(.continuousAutoExposure) else { return }
            guard camera.exposureMode != .continuousAutoExposure else { return }
            do {
                try camera.lockForConfiguration()
                camera.exposureMode = .continuousAutoExposure
                camera.unlockForConfiguration()
            } catch let error {
                debugPrint("Failed to unlock AEL: \(error)")
            }
        }
    }
    
    func capturePhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        self.sessionQueue.async {
            // Update the photo output's connection to match the video orientation of the video preview layer.
            if let photoOutputConnection = capturePhotoOutput.connection(withMediaType: AVMediaTypeVideo) {
                let deviceOrientation = UIDevice.current.orientation
                let newVideoOrientation = self.orientationMap[deviceOrientation]
                photoOutputConnection.videoOrientation = newVideoOrientation!
            }
            
            self.captureFullSizePhoto()
        }
    }
    
    private func createNewPhotoSettings() {
        photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])
        photoSettings!.isHighResolutionPhotoEnabled = true
        photoSettings!.isAutoStillImageStabilizationEnabled = true
        photoSettings!.isHighResolutionPhotoEnabled = true
        
        if currentFlashMode != nil {
            photoSettings!.flashMode = currentFlashMode!
        } else {
            currentFlashMode = photoSettings?.flashMode
        }
        
        // In addition to the full size photo, also generate a thumbnail imag (to be embedded in the jpeg header)
        let desiredPreviewPixelFormat = NSNumber(value: kCVPixelFormatType_32BGRA)
        if photoSettings!.availablePreviewPhotoPixelFormatTypes.contains(desiredPreviewPixelFormat) {
            photoSettings!.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey as String : desiredPreviewPixelFormat,
                kCVPixelBufferWidthKey as String : NSNumber(value: 512),
                kCVPixelBufferHeightKey as String : NSNumber(value: 512)
            ]
        }
    }
    
    private func captureFullSizePhoto() {
        createNewPhotoSettings()
        capturePhotoOutput.capturePhoto(with: photoSettings!, delegate: self)
    }
    
    // MARK: - AVCapturePhotoCaptureDelegate
    
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        guard error == nil, let photoSampleBuffer = photoSampleBuffer else {
            delegate?.onFatalError(errorMessage: "Error capturing photo")
            debugPrint("Error capturing photo: \(error!)")
            return
        }
        
        self.photoSampleBuffer = photoSampleBuffer
        self.previewPhotoSampleBuffer = previewPhotoSampleBuffer
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        guard error == nil else {
            delegate?.onFatalError(errorMessage: "Error processing photo")
            debugPrint("Error in capture process: \(error!)")
            return
        }
        
        if let photoSampleBuffer = self.photoSampleBuffer {
            processSampleBuffer(photoSampleBuffer, previewSampleBuffer: self.previewPhotoSampleBuffer)
        }
    }
    
    private func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, previewSampleBuffer: CMSampleBuffer?) {
        guard let jpegData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
            forJPEGSampleBuffer: sampleBuffer,
            previewPhotoSampleBuffer: previewSampleBuffer)
            else {
                delegate?.onFatalError(errorMessage: "Failed to create photo data")
                debugPrint("Unable to create JPEG data.")
                return
        }
        
        // Stop the video stream and notify the delegate that we got the photo data
        stop()
        delegate?.didCapturePhoto(data: jpegData)
    }
    
    // MARK : - Camera observers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard currentCamera != nil else { return }
        if keyPath == #keyPath(AVCaptureDevice.focusPointOfInterest) {
            delegate?.focusPointDidChange(currentCamera!.focusPointOfInterest)
        } else  if keyPath == #keyPath(AVCaptureDevice.isAdjustingFocus) {
            if currentCamera!.isAdjustingFocus {
                delegate?.focusDidStart()
            } else {
                delegate?.focusDidStop()
            }
        } else if keyPath == #keyPath(AVCaptureDevice.exposureTargetOffset) {
            delegate?.lightMeterReadingDidChange(currentCamera!.exposureTargetOffset)
        } else if keyPath == #keyPath(AVCaptureDevice.exposureDuration) {
            delegate?.shutterSpeedReadingDidChange(currentCamera!.exposureDuration)
        } else if keyPath == #keyPath(AVCaptureDevice.iso) {
            delegate?.isoReadingDidChange(currentCamera!.iso)
        } else if keyPath == #keyPath(AVCaptureDevice.exposureMode) {
            delegate?.exposureModeDidChange(currentCamera!.exposureMode)
        } else if keyPath == #keyPath(AVCaptureDevice.exposurePointOfInterest) {
            delegate?.exposurePointDidChange(currentCamera!.exposurePointOfInterest)
        }
    }
}
