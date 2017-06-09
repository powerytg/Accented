//
//  FilterManager.swift
//  Accented
//
//  Created by You, Tiangong on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

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
    private var histogramView : RenderView
    private var previewInput : PictureInput!
    
    // Filters
    private var histogramFilter = HistogramDisplay()
    private var lookupFilter = LookupFilter()
    
    // Filter chain
    private var pipelineNeedsValidation = true
    
    var lookupImageName : String? {
        didSet {
            if lookupImageName == nil {
                lookupFilter.lookupImage = nil
            } else {
                lookupFilter.lookupImage = PictureInput(imageName: lookupImageName!)
            }
            
            renderPreview()
        }
    }
    
    init(originalImage : UIImage, previewImage : UIImage, renderView : RenderView, histogramView : RenderView) {
        self.originalImage = originalImage
        self.previewImage = previewImage
        self.previewView = renderView
        self.histogramView = histogramView
        super.init()
    }

    func renderPreview() {
        // If the filter chain needs validation, then rebuild the chain
        validateFilterChainIfNecessary()
        previewInput.processImage()
    }
    
    private func validateFilterChainIfNecessary() {
        guard pipelineNeedsValidation else { return }
        pipelineNeedsValidation = false
        
        // Add all available filters
        if isValidFilter(filter: lookupFilter) {
            
        }
        
        previewInput = PictureInput(image: previewImage)
        previewInput --> lookupFilter --> previewView
        lookupFilter --> histogramFilter --> histogramView
    }

    private func isValidFilter(filter : BasicOperation) -> Bool {
        if filter is LookupFilter {
            return ((filter as! LookupFilter).lookupImage != nil)
        }
        
        return true
    }
    
}
