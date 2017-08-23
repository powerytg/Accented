//
//  FilterManager.swift
//  Accented
//
//  Created by You, Tiangong on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage
import AVFoundation
import RMessage

class FilterManager: NSObject {

    // Color preset LUT image names
    let colorPresets = ["Intensify.png",
                        "CandleLight.png",
                        "ColorPunchCool.png",
                        "ColorPunch.png",
                        "Earthy.png",
                        "FilmStock.png",
                        "Lenox.png",
                        "Remy.png",
                        "lookup_amatorka.png",
                        "lookup_miss_etikate.png",
                        "lookup_soft_elegance_2.png"]
    
    private var originalImage : UIImage
    private var previewImage : UIImage
    private var previewView : RenderView
    private var previewInput : PictureInput!
    private var cameraPosition : AVCaptureDevicePosition
    
    // Filters
    private var lookupNode = LookupFilterNode()
    private var exposureNode = ExposureFilterNode()
    private var contrastNode = ContrastFilterNode()
    private var vibranceNode = VibranceFilterNode()
    private var wbNode = WhitebalanceFilterNode()
    private var monochromeFilterNode = MonochromeFilterNode()
    private var vignetteFilterNode = VignetteFilterNode()
    private var colorFilterNode = ColorFilterNode()
    
    // Filter pipelines
    private var previewPipeline : Pipeline!
    
    var lookupImageName : String? {
        didSet {
            if lookupImageName == nil {
                if lookupNode.enabled {
                    previewPipeline.invalidate()
                }
                
                lookupNode.lookupImageName = nil
            } else {
                if !lookupNode.enabled {
                    previewPipeline.invalidate()
                }
                
                lookupNode.lookupImageName = lookupImageName
            }
            
            renderPreview()
        }
    }
    
    var exposure : Float? = 0 {
        didSet {
            exposureNode.exposure = exposure
            renderPreview()
        }
    }
    
    var contrast : Float? = 1.0 {
        didSet {
            contrastNode.contrast = contrast
            renderPreview()
        }
    }
    
    var vibrance : Float? = 0 {
        didSet {
            vibranceNode.vibrance = vibrance
            renderPreview()
        }
    }
    
    var temperature : Float = 5000 {
        didSet {
            wbNode.temperature = temperature
            renderPreview()
        }
    }
    
    var tint : Float = 0 {
        didSet {
            wbNode.tint = tint
            renderPreview()
        }
    }
    
    var enableMonochrome : Bool = false {
        didSet {
            monochromeFilterNode.enabled = enableMonochrome
            previewPipeline.invalidate()
            renderPreview()
        }
    }
    
    var monochromeIntensity : Float = 0.5 {
        didSet {
            monochromeFilterNode.intensity = monochromeIntensity
            renderPreview()
        }
    }

    var enableVignette : Bool = false {
        didSet {
            vignetteFilterNode.enabled = enableVignette
            previewPipeline.invalidate()
            renderPreview()
        }
    }
    
    var vignetteRadius : Float = 0.7 {
        didSet {
            vignetteFilterNode.radius = vignetteRadius
            renderPreview()
        }
    }
    
    var red : Float = 1.0 {
        didSet {
            colorFilterNode.red = red
            renderPreview()
        }
    }

    var green : Float = 1.0 {
        didSet {
            colorFilterNode.green = green
            renderPreview()
        }
    }

    var blue : Float = 1.0 {
        didSet {
            colorFilterNode.blue = blue
            renderPreview()
        }
    }

    init(originalImage : UIImage, previewImage : UIImage, renderView : RenderView, cameraPosition : AVCaptureDevicePosition) {
        self.originalImage = originalImage
        self.previewImage = previewImage
        self.previewView = renderView
        self.cameraPosition = cameraPosition
        super.init()
        
        initializePipelines()
    }

    private func initializePipelines() {
        previewPipeline = Pipeline()
        previewInput = PictureInput(image: previewImage)
        let inputNode = InputNode(input: previewInput)
        let outputNode = OutputNode(output: previewView)
        
        // Preview pipeline
        previewPipeline.addNode(inputNode)
        previewPipeline.addNode(wbNode)
        previewPipeline.addNode(colorFilterNode)
        previewPipeline.addNode(exposureNode)
        previewPipeline.addNode(contrastNode)
        previewPipeline.addNode(vibranceNode)
        previewPipeline.addNode(vignetteFilterNode)
        previewPipeline.addNode(lookupNode)
        previewPipeline.addNode(monochromeFilterNode)
        previewPipeline.addNode(outputNode)
    }
    
    func renderPreview() {
        previewPipeline.render()
    }
    
    func renderProductionImage(completion : @escaping ((Data) -> Void)) {
        // Normalize the original image
        var productionImage = ImageUtils.fixOrientation(originalImage, width: originalImage.size.width, height: originalImage.size.height)
        guard productionImage != nil else {
            RMessage.showNotification(withTitle: "Failed to process image", subtitle: nil, type: .error, customTypeName: nil, callback: nil)
            return
        }
        
        if cameraPosition == .front {
            productionImage = ImageUtils.flipImage(productionImage!)
            guard productionImage != nil else {
                RMessage.showNotification(withTitle: "Failed to process image", subtitle: nil, type: .error, customTypeName: nil, callback: nil)
                return
            }
        }
        
        let prodPipeline = Pipeline()
        let prodInput = PictureInput(image: productionImage!)
        let prodOutput = PictureOutput()
        let prodInputNode = InputNode(input: prodInput)
        let prodOutputNode = OutputNode(output: prodOutput)
        
        // Copy all the filter settings from the preview pipeline
        prodPipeline.addNode(prodInputNode)
        prodPipeline.addNode(wbNode.cloneFilter()!)
        prodPipeline.addNode(colorFilterNode.cloneFilter()!)
        prodPipeline.addNode(exposureNode.cloneFilter()!)
        prodPipeline.addNode(contrastNode.cloneFilter()!)
        prodPipeline.addNode(vibranceNode.cloneFilter()!)
        prodPipeline.addNode(vignetteFilterNode.cloneFilter()!)
        prodPipeline.addNode(lookupNode.cloneFilter()!)
        prodPipeline.addNode(monochromeFilterNode.cloneFilter()!)
        prodPipeline.addNode(prodOutputNode)
        
        prodOutput.encodedImageFormat = .jpeg
        prodOutput.encodedImageAvailableCallback = { (renderedData) in
            DispatchQueue.main.async {
                completion(renderedData)
            }            
        }

        prodPipeline.render()
    }
}
