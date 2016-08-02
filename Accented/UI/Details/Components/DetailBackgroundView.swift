//
//  DetailBackgroundView.swift
//  Accented
//
//  Created by Tiangong You on 8/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailBackgroundView: UIView, DetailEntranceAnimation {

    var topImageView = UIImageView(image: UIImage(named: "DetailBackgroundTop"))
    var bottomImageView = UIImageView(image: UIImage(named: "DetailBackgroundBottom"))

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        bottomImageView.contentMode = .ScaleAspectFit
        topImageView.contentMode = .ScaleAspectFit
        
        addSubview(bottomImageView)
        addSubview(topImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topImageView.frame = self.bounds
        bottomImageView.frame = self.bounds
    }
    
    // MARK: - DetailEntranceAnimation
    
    func entranceAnimationWillBegin() {
        topImageView.alpha = 0
        topImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.8, 0.8), CGAffineTransformMakeTranslation(0, 40))
        
        bottomImageView.alpha = 0
        bottomImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.8, 0.8), CGAffineTransformMakeTranslation(0, 40))
    }
    
    func performEntranceAnimation() {
        UIView .addKeyframeWithRelativeStartTime(0, relativeDuration: 0.8, animations: { [weak self] in
            self?.topImageView.alpha = 1
            self?.topImageView.transform = CGAffineTransformIdentity
        })
        
        UIView .addKeyframeWithRelativeStartTime(0.5, relativeDuration: 1.0, animations: { [weak self] in
            self?.bottomImageView.alpha = 1
            self?.bottomImageView.transform = CGAffineTransformIdentity
        })
    }
    
    func entranceAnimationDidFinish() {
        // Ignore
    }
}
