//
//  FilterSelectorView.swift
//  Accented
//
//  PearlFX filter selector view
//
//  Created by You, Tiangong on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

protocol FilterSelectorViewDelegate : NSObjectProtocol {
    func didSelectColorPreset(_ colorPreset : String?)
}

class FilterSelectorView : UIView {
    
    var filterManager : FilterManager!
    var previewImage : UIImage! {
        didSet {
            didSetPreviewImage()
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    static let thumbnailSize : CGFloat = 60
    private let gap : CGFloat = 10
    private let padding : CGFloat = 10
    private var thumbnails = [ColorPresetThumbnailView]()
    private var previewInput : PictureInput!
    private var previewOutputs = [PictureOutput]()
    
    private var selectedThumbnail : ColorPresetThumbnailView?
    var selectedColorPreset : String?
    
    weak var delegate : FilterSelectorViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func didSetPreviewImage() {
        previewInput = PictureInput(image: previewImage)
        
        // Create a "reset" thumbnail
        createColorPresetThumbnail(nil)
        
        // Create LUT thumbnails
        for lookupImage in filterManager.colorPresets {
            createColorPresetThumbnail(lookupImage)
        }
        
        // By default, select the first preset (which should be the null preset that outputs the original photo)
        let firstThumbnail = thumbnails[0]
        firstThumbnail.isSelected = true
        selectedColorPreset = firstThumbnail.colorPresetImageName
        selectedThumbnail = firstThumbnail
        
        previewInput.processImage()
        setNeedsLayout()
    }
    
    private func createColorPresetThumbnail(_ presetImageName : String?) {
        let thumbnailBounds = CGRect(x: 0, y: 0, width: FilterSelectorView.thumbnailSize, height: FilterSelectorView.thumbnailSize)
        let thumbnail = ColorPresetThumbnailView(colorPresetImageName: presetImageName, frame : thumbnailBounds)
        
        contentView.addSubview(thumbnail)
        thumbnails.append(thumbnail)
        
        if let lookupImageName = presetImageName {
            let filter = LookupFilter()
            let previewOutput = PictureOutput()
            previewOutputs.append(previewOutput)

            previewOutput.imageAvailableCallback = { (image) in
                DispatchQueue.main.async {
                    thumbnail.previewImage = image
                }
            }
            
            filter.lookupImage = PictureInput(imageName: lookupImageName)
            previewInput --> filter --> previewOutput
        } else {
            thumbnail.previewImage = previewImage
        }
        
        // Tap event
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnThumbnail(_:)))
        thumbnail.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        
        var nextX : CGFloat = padding
        let originY : CGFloat = bounds.height / 2 - FilterSelectorView.thumbnailSize / 2
        for thumbnail in thumbnails {
            thumbnail.frame.origin.x = nextX
            thumbnail.frame.origin.y = originY
            thumbnail.frame.size = CGSize(width: FilterSelectorView.thumbnailSize, height: FilterSelectorView.thumbnailSize)
            
            nextX += FilterSelectorView.thumbnailSize + gap
        }
        
        let contentWidth : CGFloat = nextX + padding
        contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: self.bounds.height)
        scrollView.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
    }
    
    @objc private func didTapOnThumbnail(_ tap : UITapGestureRecognizer) {
        let thumbnail = tap.view as! ColorPresetThumbnailView
        if let previousSelectedThumbnail = selectedThumbnail {
            previousSelectedThumbnail.isSelected = false
        }
        
        thumbnail.isSelected = true
        selectedThumbnail = thumbnail
        selectedColorPreset = thumbnail.colorPresetImageName
        delegate?.didSelectColorPreset(selectedColorPreset)
    }
}
