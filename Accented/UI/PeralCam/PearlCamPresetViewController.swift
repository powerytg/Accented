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
    @IBOutlet weak var presetSelectorView: PresetDeckView!
    
    private let landscapeImagePaddingTop : CGFloat = 80
    
    // Rendering pipeline
    private var previewInput : PictureInput!
    private var previewOutput : PictureOutput!
    private var previewImage : UIImage!
    
    // Presets
    private var presetThumbnailImage : UIImage!
    private var presetsInitialized = false
    private let presetManager = PresetManager()
    
    init(originalImage : UIImage) {
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
        
        // Create a preset thumbnail image
        let thumbnailWidth = PresetDeckView.thumbnailSize * aspectRatio
        let thumbnailHeight = PresetDeckView.thumbnailSize
        presetThumbnailImage = createPreviewImage(w: thumbnailWidth, h: thumbnailHeight)
        presetThumbnailImage = ImageUtils.fixOrientation(presetThumbnailImage, width: thumbnailWidth, height: thumbnailHeight)
        
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
        navigationController?.popViewController(animated: true)
    }
    
    private func createPreviewImage(w : CGFloat, h : CGFloat) -> UIImage {
        let size = CGSize(width: w, height: h)
        let rect = CGRect(x: 0, y: 0, width: w, height: h).integral
        
        UIGraphicsBeginImageContextWithOptions(size, false, originalImage.scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Set the quality level to use when rescaling
        context?.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: h)
        
        context?.concatenate(flipVertical)
        
        context?.draw(originalImage.cgImage!, in: rect)
        
        _ = context?.makeImage()
        let scaledImage = UIImage(cgImage: originalImage.cgImage!, scale: originalImage.scale, orientation : originalImage.imageOrientation)
        
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    // MARK: - PresetSelectorDelegate
    
    func didSelectPreset(_ preset: LookupPreset) {
        let filter = LookupPreset(preset.lookImageName).filter!
        
        previewInput.removeAllTargets()
        previewInput = PictureInput(image: previewImage)
        previewInput.addTarget(filter)
        
        previewOutput = PictureOutput()
        previewOutput.imageAvailableCallback = { [weak self] (image) in
            DispatchQueue.main.async {
                self?.previewView.image = image
            }
        }
        
        previewInput --> filter --> previewOutput
        filter --> HistogramDisplay() --> histogramView
        
        previewInput.processImage()
    }
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
        let image = originalImage!
        var orientation : ImageOrientation = .portrait
        if image.imageOrientation == .right {
            orientation = .landscapeRight
        } else if image.imageOrientation == .up {
            orientation = .portrait
        } else if image.imageOrientation == .down {
            orientation = .portraitUpsideDown
        } else if image.imageOrientation == .left {
            orientation = .landscapeLeft
        }

        let input = PictureInput(image: image, smoothlyScaleOutput: false, orientation: orientation)
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
            let filter = LookupPreset(selectedPreset.lookImageName).filter!
            input --> filter --> output2
        } else {
            input --> output2
        }
        
        input.processImage(synchronously: true)
    }
}
