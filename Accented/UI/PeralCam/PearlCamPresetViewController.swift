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

class PearlCamPresetViewController: UIViewController {

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
    
    private let landscapeImagePaddingTop : CGFloat = 80
    
    // Rendering pipeline
    private var previewInput : PictureInput!
    private var previewOutput : PictureOutput!
    
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
        var scaledImage = createPreviewImage(w: previewWidth, h: previewHeight)
        scaledImage = fixOrientation(scaledImage, width: previewWidth, height: previewHeight)!
        
        // Setup the initial render pipeline
        previewInput = PictureInput(image: scaledImage)
        previewOutput = PictureOutput()
        previewOutput.imageAvailableCallback = { [weak self] (image) in
            DispatchQueue.main.async {
                self?.previewView.image = image
            }
        }
        
        previewInput --> previewOutput
        
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
    
    private func correctedImageOrientation(image : UIImage) -> ImageOrientation {
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
        
        return orientation
    }
    
    // https://stackoverflow.com/a/33260568
    private func fixOrientation(_ input : UIImage, width : CGFloat, height : CGFloat) -> UIImage? {
        
        guard let cgImage = input.cgImage else {
            return nil
        }
        
        if input.imageOrientation == UIImageOrientation.up {
            return input
        }
        
        var transform = CGAffineTransform.identity
        
        switch input.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat.pi)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: 0.5*CGFloat.pi)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: -0.5*CGFloat.pi)
            
        case .up, .upMirrored:
            break
        }
        
        switch input.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
            ) else {
                return nil
        }
        
        context.concatenate(transform);
        
        switch input.imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
            
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let newCGImg = context.makeImage() else {
            return nil
        }
        
        let img = UIImage(cgImage: newCGImg)
        
        return img;
    }
}
