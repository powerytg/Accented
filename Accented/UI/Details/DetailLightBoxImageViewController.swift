//
//  DetailLightBoxImageViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/8/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class DetailLightBoxImageViewController: CardViewController {

    // Image view
    private var imageView  = UIImageView()
    
    // Photo model
    var photo : PhotoModel? {
        didSet {
            if photo == nil {
                imageView.image = nil
            } else {
                imageView.af_setImageWithURL(NSURL(string: photo!.imageUrls[.Large]!)!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(imageView)
        imageView.contentMode = .ScaleAspectFit
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = self.view.bounds
    }

    override func cardSelectionDidChange(selected: Bool) {
        super.cardSelectionDidChange(selected)
    }

    // Entrance animation
    
    func desitinationRectForProxyView(photo: PhotoModel) -> CGRect {
        return self.view.bounds
    }
}
