//
//  DetailViewController.swift
//  Accented
//
//  Created by Tiangong You on 7/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var photo : PhotoModel!
    
    var sectionViews = [DetailSectionViewBase]()
    
    @IBOutlet weak var scrollView: UIScrollView!
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
}
