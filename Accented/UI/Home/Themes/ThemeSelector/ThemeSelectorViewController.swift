//
//  ThemeSelectorViewController.swift
//  Accented
//
//  Created by Tiangong You on 6/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class ThemeSelectorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var themeCollectionView: UICollectionView!

    static let drawerWidthInPercentage : CGFloat = 0.8
    
    private var themeCellIdentifier = "themeCell"
    private var footerIdentifier = "themeFooter"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.streamBackgroundColor;
        
        // Register cell types
        let cellNib = UINib(nibName: "ThemeSelectorRenderer", bundle: nil)
        themeCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: themeCellIdentifier)
        
        let footerNib = UINib(nibName: "ThemeSelectorFooterRenderer", bundle: nil)
        themeCollectionView.registerNib(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
        themeCollectionView.dataSource = self
        themeCollectionView.delegate = self
        
        // Layout 
        let porpotion : CGFloat = 0.45
        let w : CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds) * ThemeSelectorViewController.drawerWidthInPercentage
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(w, w * porpotion)
        themeCollectionView.collectionViewLayout = layout
        themeCollectionView.contentInset = UIEdgeInsetsMake(155, 0, 10, 0)
        
        // Select the current theme
        let currentThemeIndex = ThemeManager.sharedInstance.themes.indexOf(ThemeManager.sharedInstance.currentTheme)!
        let currentThemePath = NSIndexPath(forItem: currentThemeIndex, inSection: 0)
        themeCollectionView.selectItemAtIndexPath(currentThemePath, animated: false, scrollPosition: .Top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).CGPath
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.65;
        self.view.layer.shadowRadius = 5
        self.view.layer.shadowOffset = CGSizeMake(-3, 0)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ThemeManager.sharedInstance.themes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(themeCellIdentifier, forIndexPath: indexPath) as! ThemeSelectorRenderer
        cell.theme = ThemeManager.sharedInstance.themes[indexPath.item]
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(CGRectGetWidth(self.view.bounds), 100)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedTheme = ThemeManager.sharedInstance.themes[indexPath.item]
        ThemeManager.sharedInstance.currentTheme = selectedTheme
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
