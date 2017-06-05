//
//  PresetDeckView.swift
//  Accented
//
//  Deck view that allows user to select a preset
//
//  Created by Tiangong You on 6/4/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

protocol PresetSelectorDelegate : NSObjectProtocol {
    func didSelectPreset(_ preset : LookupPreset)
}

class PresetDeckView: UIView {

    private var presetManager = PresetManager()
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
    private var thumbnails = [PresetThumbnailView]()
    private var previewInput : PictureInput!
    private var previewOutputs = [PictureOutput]()
    private var selectedThumbnail : PresetThumbnailView?
    var selectedPreset : LookupPreset?
    
    weak var delegate : PresetSelectorDelegate?
    
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
        
        // Create thumbnails
        for preset in presetManager.availablePresets {
            let thumbnail = PresetThumbnailView(preset: preset)
            let previewOutput = PictureOutput()
            previewOutputs.append(previewOutput)
            
            contentView.addSubview(thumbnail)
            thumbnails.append(thumbnail)
            
            previewInput --> preset.filter --> previewOutput
            
            previewOutput.imageAvailableCallback = { (image) in
                DispatchQueue.main.async {
                    thumbnail.previewImage = image
                }
            }
            
            // Tap event
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnThumbnail(_:)))
            thumbnail.addGestureRecognizer(tap)
        }
        
        previewInput.processImage()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        
        var nextX : CGFloat = padding
        let originY : CGFloat = bounds.height / 2 - PresetDeckView.thumbnailSize / 2
        for thumbnail in thumbnails {
            thumbnail.frame.origin.x = nextX
            thumbnail.frame.origin.y = originY
            thumbnail.frame.size = CGSize(width: PresetDeckView.thumbnailSize, height: PresetDeckView.thumbnailSize)
            
            nextX += PresetDeckView.thumbnailSize + gap
        }
        
        let contentWidth : CGFloat = nextX + padding
        contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: self.bounds.height)
        scrollView.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
    }
    
    @objc fileprivate func didTapOnThumbnail(_ tap : UITapGestureRecognizer) {
        let thumbnail = tap.view as! PresetThumbnailView
        if let previousSelectedThumbnail = selectedThumbnail {
            previousSelectedThumbnail.isSelected = false
        }
        
        thumbnail.isSelected = true
        selectedThumbnail = thumbnail
        selectedPreset = thumbnail.preset as! LookupPreset
        
        delegate?.didSelectPreset(thumbnail.preset as! LookupPreset)
    }
}
