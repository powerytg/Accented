//
//  PearlCamPresetViewController.swift
//  Accented
//
//  PearlCam built-in image preset view controller
//
//  Created by Tiangong You on 6/4/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage
import Photos

class PearlCamPresetViewController: UIViewController, PresetSelectorDelegate {

    // The original image from the camera
    var originalImage : UIImage!
    var cameraPosition : AVCaptureDevicePosition
        
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var currentFilterLabel: UILabel!
    @IBOutlet weak var imageInfoLabel: UILabel!
    @IBOutlet weak var previewView: UIImageView!
    @IBOutlet weak var previewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var previewHeightConstraint: NSLayoutConstraint!    
    @IBOutlet weak var histogramView: RenderView!
    @IBOutlet weak var presetSelectorView: PresetChooserView!
    
    private let landscapeImagePaddingTop : CGFloat = 80
    
    // Rendering pipeline
    private var previewInput : PictureInput!
    private var previewOutput : PictureOutput!
    private var previewImage : UIImage!
    
    // Presets
    private var presetThumbnailImage : UIImage!
    private var presetsInitialized = false
    private let presetManager = PresetManager()
    
    init(originalImage : UIImage, cameraPosition : AVCaptureDevicePosition) {
        self.cameraPosition = cameraPosition
        self.originalImage = originalImage
        super.init(nibName: "PearlCamPresetViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePreview()
        presetSelectorView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !presetsInitialized {
            presetsInitialized = true
            presetSelectorView.previewImage = presetThumbnailImage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func initializePreview() {
        // Calculate a fitting preview size
        let aspectRatio = originalImage.size.height / originalImage.size.width
        
        // Scale the image to match the screen size
        let w = view.bounds.width
        let h = w * aspectRatio
        previewHeightConstraint.constant = h
        
        let previewWidth = w * UIScreen.main.scale
        let previewHeight = h * UIScreen.main.scale
        
        // Layout preview image
        if originalImage.size.width < originalImage.size.height {
            // If the image is portrait, we'll align the image to top of the screen
            previewTopConstraint.constant = 0
        } else {
            // If the image is portrait, we'll leave some empty spaces to top of the screen
            previewTopConstraint.constant = landscapeImagePaddingTop
        }

        // Create a preview with normalized orientation
        previewImage = createPreviewImage(w: previewWidth, h: previewHeight)
        previewImage = ImageUtils.fixOrientation(previewImage, width: previewWidth, height: previewHeight)!
        
        // The front camera always returns an image flipped, so we need to fix that
        if cameraPosition == .front {
            previewImage = ImageUtils.flipImage(previewImage)
        }
        
        // Create a preset thumbnail image
        let thumbnailWidth = PresetChooserView.thumbnailSize
        let thumbnailHeight = PresetChooserView.thumbnailSize * aspectRatio
        presetThumbnailImage = createPreviewImage(w: thumbnailWidth, h: thumbnailHeight)
        presetThumbnailImage = ImageUtils.fixOrientation(presetThumbnailImage, width: thumbnailWidth, height: thumbnailHeight)
        if cameraPosition == .front {
            presetThumbnailImage = ImageUtils.flipImage(presetThumbnailImage)
        }

        // Setup the initial render pipeline
        previewInput = PictureInput(image: previewImage)
        previewOutput = PictureOutput()
        previewOutput.imageAvailableCallback = { [weak self] (image) in
            DispatchQueue.main.async {
                self?.previewView.image = image
            }
        }
        
        previewInput --> previewOutput
        
        // Initialize an histogram view
        previewInput --> HistogramDisplay() --> histogramView
        
        // Render an initial preview
        view.setNeedsDisplay()
        previewInput.processImage()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func createPreviewImage(w : CGFloat, h : CGFloat) -> UIImage {
        let image = originalImage.cgImage!
        let context = CGContext(data: nil, width: Int(w), height: Int(h), bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: image.colorSpace!, bitmapInfo: image.bitmapInfo.rawValue)!
        context.interpolationQuality = .high
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: w, height: h))
        context.draw(image, in: rect)
        let scaledImage = context.makeImage()!
        return UIImage(cgImage: scaledImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
    }
    
    // MARK: - PresetSelectorDelegate
    
    func didSelectPreset(_ preset: Preset) {
        var filter : LookupFilter? = nil
        if preset is LookupPreset {
            let lookupPreset = preset as! LookupPreset
            filter = LookupPreset(lookupPreset.lookImageName).filter!
        }
        
        previewInput.removeAllTargets()
        previewInput = PictureInput(image: previewImage)
        previewOutput = PictureOutput()
        previewOutput.imageAvailableCallback = { [weak self] (image) in
            DispatchQueue.main.async {
                self?.previewView.image = image
            }
        }

        if filter != nil {
            previewInput --> filter! --> previewOutput
            filter! --> HistogramDisplay() --> histogramView
        } else {
            previewInput --> previewOutput
            previewInput --> histogramView
        }
        
        previewInput.processImage()
    }
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        var image = ImageUtils.fixOrientation(originalImage, width: originalImage.size.width, height: originalImage.size.height)!
        if cameraPosition == .front {
            image = ImageUtils.flipImage(image)
        }

        let input = PictureInput(image: image)
        let output2 = PictureOutput()

        output2.encodedImageFormat = .jpeg
        output2.encodedImageAvailableCallback = { (renderedData) in
                    PHPhotoLibrary.shared().performChanges( {
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: PHAssetResourceType.photo, data: renderedData, options: nil)
                    }, completionHandler: { success, error in
                        DispatchQueue.main.async {
                            // Ignore
                        }
                    })
        }

        if let selectedPreset = presetSelectorView.selectedPreset {
            let preset = selectedPreset as! LookupPreset
            let filter = LookupPreset(preset.lookImageName).filter!
            input --> filter --> output2
        } else {
            input --> output2
        }
        
        input.processImage(synchronously: true)
    }
}
