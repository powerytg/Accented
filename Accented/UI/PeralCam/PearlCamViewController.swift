//
//  PearlCamViewController.swift
//  Accented
//
//  PearlCam camera view controller
//
//  Created by Tiangong You on 6/2/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import GPUImage

class PearlCamViewController: UIViewController, CameraOverlayDelegate, CameraDelegate {
    // Camera UI overlay
    var overlay : CameraUIViewController?
    
    // Fatal error view
    var fatalErrorView : FatalErrorView?
    
    // Camera
    var camera : CameraController!
    
    // Preview layer
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // Whether the UI has been initialized
    var isUIInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        camera = CameraController(position : .back)
        camera.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if checkCameraPermission() {
            didGrantedCameraPermisison()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        camera.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        overlay?.view.frame = view.bounds
        
        // We always take the default, fixed 4/3 photo, so position the preview layer accordingly
        if let preview = previewLayer {
            let aspectRatio = CGFloat(4.0 / 3.0)
            preview.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * aspectRatio)
        }
    }
    
    // MARK : - Permission
    
    private func checkCameraPermission() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType:AVMediaTypeVideo)
        switch authStatus {
        case .denied:
            showDeniedCameraPermissionView()
            return false
        case .restricted:
            showResrictedAccessErrorView()
            return false
        case .authorized:
            return true
        case .notDetermined:
            requestCameraAccess()
            return false
        }
    }
    
    fileprivate func requestCameraAccess() {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { [weak self] (granted) in
            if granted {
                self?.didGrantedCameraPermisison()
            } else {
                self?.showDeniedCameraPermissionView()
            }
        }
    }
    
    fileprivate func showFatalErrorView(text : String, buttonText : String, action : @escaping (() -> Void)) {
        // If there's a previous fatal error view, dismiss it
        if fatalErrorView != nil {
            view.willRemoveSubview(fatalErrorView!)
            fatalErrorView = nil
        }
        
        fatalErrorView = FatalErrorView(frame: view.bounds, title: text, buttonTitle: buttonText, action: action)
        
        fatalErrorView!.alpha = 0
        view.addSubview(fatalErrorView!)
        UIView.animate(withDuration: 0.2) {
            self.fatalErrorView!.alpha = 1
        }
    }
    
    fileprivate func showDeniedCameraPermissionView() {
        let text = "You have previously denied the app to use camera\nYou can enable the camera access in the settings app"
        showFatalErrorView(text: text, buttonText: "GO TO SETTINGS") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            }
        }
    }
    
    fileprivate func showResrictedAccessErrorView() {
        let text = "Your access to the camera has been restricted"
        showFatalErrorView(text: text, buttonText: "GO BACK") {
            self.navigationController?.popViewController(animated: true)
        }
    }

    fileprivate func showCameraInitializationErrorView() {
        let text = "Failed to initialize camera"
        showFatalErrorView(text: text, buttonText: "GO BACK") {
            self.navigationController?.popViewController(animated: true)
        }
    }

    fileprivate func didGrantedCameraPermisison() {
        // Dismiss any of the previous fatal error view
        if fatalErrorView != nil {
            view.willRemoveSubview(fatalErrorView!)
            fatalErrorView = nil
        }

        // Setup camera
        if !camera.isInitialized {
            camera.initializeCamera({ (success) in
                if success {
                    cameraDidFinishInitialization(success)
                } else {
                    showCameraInitializationErrorView()
                }
            })
        } else {
            camera.start()
        }
    }

    fileprivate func cameraDidFinishInitialization(_ success : Bool) {
        if success {
            initializeOverlayIfNecessary()
            camera.start()
        } else {
            showCameraInitializationErrorView()
        }
    }
    
    fileprivate func initializeOverlayIfNecessary() {
        if isUIInitialized {
            return
        }
        
        // Setup UI overlay
        isUIInitialized = true
        overlay = CameraUIViewController()
        addChildViewController(overlay!)
        self.view.addSubview(overlay!.view)
        overlay!.view.frame = self.view.bounds
        overlay!.didMove(toParentViewController: self)
        overlay!.delegate = self
    }
    
    // MARK: - CameraDelegate
    
    func previewLayerBecomeAvailable(_ previewLayer: AVCaptureVideoPreviewLayer) {
        if let preview = self.previewLayer {
            preview.removeFromSuperlayer()
        }
        
        self.previewLayer = previewLayer
        view.layer.insertSublayer(previewLayer, at: 0)
    }
    
    func onFatalError(errorMessage: String) {
        showFatalErrorView(text: errorMessage, buttonText: "GO BACK") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func didCapturePhoto(data: Data) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization({  [weak self] (newStatus) in
                if newStatus == .authorized {
                    self?.onImageDataReceived(data)
                }
            })
        } else if authStatus == .authorized {
            onImageDataReceived(data)
        }
    }
    
    // MARK : - CameraOverlayDelegate
    func switchCameraButtonDidTap() {
        if camera.cameraPosition == .back {
            camera = CameraController(position : .front)
            camera.delegate = self
            camera.initializeCamera({ (success) in
                cameraDidFinishInitialization(success)
            })
        } else {
            camera = CameraController(position : .back)
            camera.delegate = self
            camera.initializeCamera({ (success) in
                cameraDidFinishInitialization(success)
            })
        }
    }
    
    func shutterButtonDidTap() {
        camera.capturePhoto()
    }
    
    // MARK : - Image processing
    private func onImageDataReceived(_ data : Data) {
//        PHPhotoLibrary.shared().performChanges( {
//            let creationRequest = PHAssetCreationRequest.forAsset()
//            creationRequest.addResource(with: PHAssetResourceType.photo, data: data, options: nil)
//        }, completionHandler: { success, error in
//            DispatchQueue.main.async {
//                completionHandler?(success, error)
//            }
//        })
        
//        let image = UIImage(data: data)!
//        var orientation : ImageOrientation = .portrait
//        if image.imageOrientation == .right {
//            orientation = .landscapeRight
//        } else if image.imageOrientation == .up {
//            orientation = .portrait
//        } else if image.imageOrientation == .down {
//            orientation = .portraitUpsideDown
//        } else if image.imageOrientation == .left {
//            orientation = .landscapeLeft
//        }
//        
//        let input = PictureInput(image: image, smoothlyScaleOutput: false, orientation: orientation)
//        let output2 = PictureOutput()
//        
//        output2.encodedImageFormat = .jpeg
//        output2.encodedImageAvailableCallback = { (renderedData) in
//                    PHPhotoLibrary.shared().performChanges( {
//                        let creationRequest = PHAssetCreationRequest.forAsset()
//                        creationRequest.addResource(with: PHAssetResourceType.photo, data: renderedData, options: nil)
//                    }, completionHandler: { success, error in
//                        DispatchQueue.main.async {
//                            completionHandler?(success, error)
//                        }
//                    })
//        }
//        
//        let filter = LookupFilter()
//        filter.lookupImage = PictureInput(imageName:"white.png")
//
//        input --> filter --> output2
//        input.processImage(synchronously: true)
     
        var image = UIImage(data: data)
        guard image != nil else {
            onFatalError(errorMessage: "Failed to process image")
            return
        }
        
        let presetsVC = PearlCamPresetViewController(originalImage: image!, cameraPosition : camera.cameraPosition)
        navigationController?.pushViewController(presetsVC, animated: true)
    }
}
