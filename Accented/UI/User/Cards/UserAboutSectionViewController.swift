//
//  UserAboutSectionViewController.swift
//  Accented
//
//  The about section in user profile page
//
//  Created by Tiangong You on 5/28/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class UserAboutSectionViewController: UserProfileCardViewController {

    // Sections
    fileprivate var sections = [UserSectionViewBase]()
    
    // Content view
    fileprivate var scrollView : UIScrollView!
    fileprivate var contentView = UIView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ABOUT"
        scrollView = UIScrollView(frame: view.bounds)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Initialize sections
        let width = view.bounds.size.width
        var contentHeight : CGFloat = 0
        if user.about != nil {
            let descSection = UserDescSectionView(user: user, width: width)
            sections.append(descSection)
            contentView.addSubview(descSection)
            contentHeight += descSection.height
        }
        
        let infoSection = UserInfoSectionView(user: user, width: width)
        sections.append(infoSection)
        contentView.addSubview(infoSection)
        contentHeight += infoSection.height
        
        // Calculate the overall content size
        scrollView.contentSize = CGSize(width: width, height: contentHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.bounds
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        var nextY : CGFloat = 0
        for section in sections {
            var f = section.frame
            f.origin.y = nextY
            f.size.width = view.bounds.size.width
            f.size.height = section.height
            section.frame = f
            section.setNeedsLayout()
            
            nextY += section.height
        }
    }
    
    override func adjustTextClarity() {
        for section in sections {
            section.adjustTextClarity()
        }
    }
}
