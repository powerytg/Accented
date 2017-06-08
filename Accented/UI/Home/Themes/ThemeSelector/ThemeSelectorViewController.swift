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
        themeCollectionView.register(cellNib, forCellWithReuseIdentifier: themeCellIdentifier)
        
        let footerNib = UINib(nibName: "ThemeSelectorFooterRenderer", bundle: nil)
        themeCollectionView.register(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier)
        
        themeCollectionView.dataSource = self
        themeCollectionView.delegate = self
        
        // Layout 
        let porpotion : CGFloat = 0.45
        let w : CGFloat = UIScreen.main.bounds.width * ThemeSelectorViewController.drawerWidthInPercentage
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: w, height: w * porpotion)
        themeCollectionView.collectionViewLayout = layout
        themeCollectionView.contentInset = UIEdgeInsetsMake(155, 0, 10, 0)
        
        // Select the current theme
        let currentThemeIndex = ThemeManager.sharedInstance.themes.index(of: ThemeManager.sharedInstance.currentTheme)!
        let currentThemePath = IndexPath(item: currentThemeIndex, section: 0)
        themeCollectionView.selectItem(at: currentThemePath, animated: false, scrollPosition: .top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOpacity = 0.65;
        self.view.layer.shadowRadius = 5
        self.view.layer.shadowOffset = CGSize(width: -3, height: 0)
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ThemeManager.sharedInstance.themes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: themeCellIdentifier, for: indexPath) as! ThemeSelectorRenderer
        cell.theme = ThemeManager.sharedInstance.themes[(indexPath as NSIndexPath).item]
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 100)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTheme = ThemeManager.sharedInstance.themes[(indexPath as NSIndexPath).item]
        ThemeManager.sharedInstance.currentTheme = selectedTheme
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
