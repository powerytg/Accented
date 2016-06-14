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
    
    private var themeCellIdentifier = "themeCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ThemeManager.sharedInstance.currentTheme.streamBackgroundColor;
        
        // Register cell types
        let cellNib = UINib(nibName: "ThemeSelectorRenderer", bundle: nil)
        themeCollectionView.registerNib(cellNib, forCellWithReuseIdentifier: themeCellIdentifier)
        themeCollectionView.dataSource = self
        themeCollectionView.delegate = self
        
        // Layout 
        let porpotion : CGFloat = 0.45
        let w : CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds) * DrawerViewController.drawerPercentageWidth
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(w, w * porpotion)
        themeCollectionView.collectionViewLayout = layout
        themeCollectionView.contentInset = UIEdgeInsetsMake(155, 0, 40, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedTheme = ThemeManager.sharedInstance.themes[indexPath.item]
        ThemeManager.sharedInstance.currentTheme = selectedTheme
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
