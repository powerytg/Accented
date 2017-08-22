//
//  MeterView.swift
//  PearlCam
//
//  MeterView is a slider that allows users to swipe through the specified range of values
//
//  Created by Tiangong You on 6/11/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import CRRulerControl

enum MeterType {
    case exposureCompensation
    case iso
    case shutterSpeed
}

protocol MeterViewDelegate : NSObjectProtocol {
    func meterValueDidChange(_ value : Float)
}

class MeterView: UIView {
    
    private var backgroundView = UIImageView(image: UIImage(named: "SliderBackground"))
    var rulerView = CRRulerControl()
    
    weak var delegate : MeterViewDelegate?
    
    private var meterType : MeterType
    private var minValue : CGFloat
    private var maxValue : CGFloat
    private var value : CGFloat
    
    init(meterType : MeterType, minValue : Float, maxValue : Float, currentValue : Float, frame : CGRect) {
        self.meterType = meterType
        self.minValue = CGFloat(minValue)
        self.maxValue = CGFloat(maxValue)
        self.value = CGFloat(currentValue)
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        rulerView.frame = self.bounds.insetBy(dx: 8, dy: 3)
        addSubview(backgroundView)
        addSubview(rulerView)
        
        rulerView.setColor(UIColor.white, for: .all)
        rulerView.setTextColor(UIColor.white, for: .all)
        rulerView.rangeFrom = minValue
        rulerView.rangeLength = maxValue - minValue
        rulerView.setValue(value, animated: false)
        
        switch meterType {
        case .exposureCompensation:
            rulerView.rulerWidth = self.bounds.width * 1.4
            rulerView.spacingBetweenMarks = 30
        case .iso:
            rulerView.setFrequency(50, for: .all)
            rulerView.rulerWidth = self.bounds.width * 2.0
            rulerView.spacingBetweenMarks = 60
        case .shutterSpeed:
            rulerView.setFrequency(50, for: .all)
            rulerView.rulerWidth = self.bounds.width * 2.4
            rulerView.spacingBetweenMarks = 60
        }
        
        rulerView.setNeedsLayout()
        rulerView.addTarget(self, action: #selector(rulerValueDidChange(_:)), for: .valueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = self.bounds        
    }
    
    @objc private func rulerValueDidChange(_ sender : CRRulerControl) {
        delegate?.meterValueDidChange(Float(rulerView.value))
    }
}
