//
//  DetailViewController.swift
//  Accented
//
//  Created by Tiangong You on 7/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailEntranceProxyAnimation {

    var photo : PhotoModel
    var sourceImageView : UIImageView
    
    var sectionViews = [DetailSectionViewBase]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    init(photo : PhotoModel, sourceImageView : UIImageView) {
        self.photo = photo
        self.sourceImageView = sourceImageView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSections()
    }

    private func setupSections() {
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        let w = CGRectGetWidth(UIScreen.mainScreen().bounds)
        sectionViews.append(DetailOverviewSectionView(photo: photo, maxWidth: w))
        
        var nextY : CGFloat = 0
        for section in sectionViews {
            contentView.addSubview(section)
            let sectionHeight = section.estimatedHeight(w)
            let sectionFrame = CGRectMake(0, nextY, w, sectionHeight)
            section.frame = sectionFrame
            
            nextY += sectionHeight
        }
        
        contentView.frame = CGRectMake(0, 0, w, nextY)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Animations
    
    func entranceAnimationWillBegin() {
        for sectionView in sectionViews {
            sectionView.entranceAnimationWillBegin()
        }
    }
    
    func performEntranceAnimation() {
        for sectionView in sectionViews {
            sectionView.performEntranceAnimation()
        }
    }
    
    func entranceAnimationDidFinish() {
        for sectionView in sectionViews {
            sectionView.entranceAnimationDidFinish()
        }
    }
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        return DetailOverviewSectionView.targetRectForPhotoView(photo)
    }
    
}
