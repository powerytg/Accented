//
//  MainMenuViewController.swift
//  Accented
//
//  Created by Tiangong You on 8/27/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class MainMenuViewController: SectionViewController {

    static let drawerWidthInPercentage : CGFloat = 0.8
    
    private var backgroundView : DetailBackgroundView!
    private var avatarView = UIImageView()
    private var currentUserLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView = DetailBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
        
        addSection(MainMenuHeaderSectionView(drawer : self))
        addSection(MainMenuAuthenticatedUserSectionView(drawer : self))
        addSection(MainMenuThemeSectionView(drawer : self))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        backgroundView.frame = view.bounds
    }
    
    override func goBack() {
        dismiss(animated: true, completion: nil)
    }
}
