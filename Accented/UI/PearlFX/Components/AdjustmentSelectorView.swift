//
//  AdjustmentSelectorView.swift
//  PearlCam
//
//  A panel that contains various advanced adjustment filters
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol AdjustmentSelectorDelegate : NSObjectProtocol {
    func didRequestExposureFilterUI()
    func didRequestWhiteBalanceFilterUI()
    func didRequestMonochromeFilterUI()
    func didRequestVignetteFilterUI()
    func didRequestColorFilterUI()
}

class AdjustmentSelectorView: UIView {
    private let buttonSize : CGFloat = 40
    private let gap : CGFloat = 10
    private let padding : CGFloat = 10

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var exposureFilterButton : UIButton!
    private var colorFilterButton : UIButton!
    private var whiteBalanceFilterButton : UIButton!
    private var vignetteFilterButton : UIButton!
    private var monoFilterButton : UIButton!
    private var buttons = [UIButton]()

    weak var delegate : AdjustmentSelectorDelegate?
    
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

        // Create filter buttons
        exposureFilterButton = createFilterButton("ExposureFilterIcon")
        whiteBalanceFilterButton = createFilterButton("WhiteBalanceFilterIcon")
        colorFilterButton = createFilterButton("ColorFilterIcon")
        monoFilterButton = createFilterButton("MonochromeFilterIcon")
        vignetteFilterButton = createFilterButton("FXFilterIcon")
        buttons = [exposureFilterButton, whiteBalanceFilterButton, colorFilterButton, monoFilterButton, vignetteFilterButton]
        
        for button in buttons {
            contentView.addSubview(button)
        }
        
        // Events
        exposureFilterButton.addTarget(self, action: #selector(exposureButtonDidTap(_:)), for: .touchUpInside)
        whiteBalanceFilterButton.addTarget(self, action: #selector(whiteBalanceButtonDidTap(_:)), for: .touchUpInside)
        monoFilterButton.addTarget(self, action: #selector(monoButtonDidTap(_:)), for: .touchUpInside)
        colorFilterButton.addTarget(self, action: #selector(colorButtonDidTap(_:)), for: .touchUpInside)
        vignetteFilterButton.addTarget(self, action: #selector(vignetteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private func createFilterButton(_ icon : String) -> UIButton {
        let image = UIImage(named: icon)
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.setImage(image, for: .normal)
        
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        
        let totalButtonWidth = FilterSelectorView.thumbnailSize * CGFloat(buttons.count) + gap * CGFloat(buttons.count - 1)
        var nextX : CGFloat = bounds.width / 2 - totalButtonWidth / 2
        let originY : CGFloat = bounds.height / 2 - buttonSize / 2
        for button in buttons {
            button.frame.origin.x = nextX
            button.frame.origin.y = originY
            button.frame.size = CGSize(width: buttonSize, height: buttonSize)
            
            nextX += FilterSelectorView.thumbnailSize + gap
        }
        
        let contentWidth : CGFloat = nextX + padding
        contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: self.bounds.height)
        scrollView.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
    }
    
    @objc private func exposureButtonDidTap(_ sender : UIButton) {
        delegate?.didRequestExposureFilterUI()
    }

    @objc private func whiteBalanceButtonDidTap(_ sender : UIButton) {
        delegate?.didRequestWhiteBalanceFilterUI()
    }

    @objc private func monoButtonDidTap(_ sender : UIButton) {
        delegate?.didRequestMonochromeFilterUI()
    }

    @objc private func colorButtonDidTap(_ sender : UIButton) {
        delegate?.didRequestColorFilterUI()
    }
    
    @objc private func vignetteButtonDidTap(_ sender : UIButton) {
        delegate?.didRequestVignetteFilterUI()
    }
}
