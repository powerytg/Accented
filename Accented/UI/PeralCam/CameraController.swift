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
}

class CameraController: NSObject, AVCapturePhotoCaptureDelegate {
    fileprivate var captureSession = AVCaptureSession()
    fileprivate var capturePhotoOutput : AVCapturePhotoOutput!
    fileprivate let sessionQueue = DispatchQueue.global(qos: .default)
    var isInitialized = false
    
    fileprivate var currentCamera : AVCaptureDevice?
    fileprivate var frontCamera : AVCaptureDevice?
    fileprivate var backCamera : AVCaptureDevice?
    
    var cameraPosition : AVCaptureDevicePosition
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    
    var context = CIContext()
    var faceDetector : CIDetector!
    
    weak var delegate : CameraDelegate?
    
    init(position : AVCaptureDevicePosition) {
        cameraPosition = position
        super.init()
        
        // Check for available cameras
        initializeDeviceSupport()
    }
    
    fileprivate func initializeDeviceSupport() {
        frontCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
        backCamera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
    }
    
    fileprivate var orientationMap: [UIDeviceOrientation : AVCaptureVideoOrientation] = [
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
        
        currentCamera = device
        isInitialized = true
        success = true
    }
    
    private func initializeFaceDetector() {
        let options = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
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
    
    fileprivate func captureFullSizePhoto() {
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        // In addition to the full size photo, also generate a thumbnail imag (to be embedded in the jpeg header)
        let desiredPreviewPixelFormat = NSNumber(value: kCVPixelFormatType_32BGRA)
        if photoSettings.availablePreviewPhotoPixelFormatTypes.contains(desiredPreviewPixelFormat) {
            photoSettings.previewPhotoFormat = [
                kCVPixelBufferPixelFormatTypeKey as String : desiredPreviewPixelFormat,
                kCVPixelBufferWidthKey as String : NSNumber(value: 512),
                kCVPixelBufferHeightKey as String : NSNumber(value: 512)
            ]
        }
        
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
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
}
