//
//  SectionViewController.swift
//  Accented
//
//  Base class supporting section style view controllers
//
//  Created by Tiangong You on 8/23/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class SectionViewController: UIViewController, SectionViewDelegate, UIScrollViewDelegate {

    private let contentBottomPadding : CGFloat = 25
    private let sectionGap : CGFloat = 15

    // Sections and UI elements
    var sections = [SectionViewBase]()
    var scrollView = UIScrollView()
    var contentView = UIView()
    var backButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = false
        self.view.backgroundColor = UIColor.clear
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Setup scroll view and content view
        scrollView.clipsToBounds = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        self.view.addSubview(scrollView)
        
        // Back button
        self.view.addSubview(backButton)
        backButton.setImage(UIImage(named: "DetailBackButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        backButton.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addSection(_ section : SectionViewBase) {
        sections.append(section)
        section.delegate = self
        contentView.addSubview(section)
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Do not proceed if we're in landscape mode
        if view.bounds.size.width > view.bounds.size.height {
            return
        }
        
        // Back button
        var f = backButton.frame
        f.origin.x = 10
        f.origin.y = 30
        backButton.frame = f
        
        // Content view
        var nextY : CGFloat = 0
        for (index, section) in sections.enumerated() {
            var f = section.frame
            f.origin.y = nextY
            f.size.width = view.bounds.size.width
            f.size.height = section.height
            section.frame = f
            section.setNeedsLayout()
            
            nextY += section.height
            
            section.isHidden = !(section.height > 0)
            if section.height != 0 && !(index == 0) {
                // For each of the section, append a gap to its bottom (except for the header section)
                nextY += sectionGap
            }
        }
        
        // Update scroll view content size
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: nextY + contentBottomPadding)
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    // MARK: - Events
    
    @objc private func backButtonDidTap(_ sender : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - SectionViewDelegate
    
    func sectionViewWillChangeSize(_ section: SectionViewBase) {
        view.setNeedsLayout()
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Base class do nothing
    }
}
