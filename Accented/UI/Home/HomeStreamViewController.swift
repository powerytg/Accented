//
//  HomeStreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class HomeStreamViewController: StreamViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Events
        NotificationCenter.default.addObserver(self, selector: #selector(appThemeDidChange(_:)), name: ThemeManagerEvents.appThemeDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createViewModel() {
        let viewModelClass = ThemeManager.sharedInstance.currentTheme.streamViewModelClass
        viewModel = viewModelClass.init(stream: stream!, collectionView: collectionView, flowLayoutDelegate: self)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            // Section 0 is reserved for stream headers
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 8)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        
        return CGSize(width: collectionView.bounds.width, height: 26)
    }
    
    // MARK: - Events
    func appThemeDidChange(_ notification : Notification) {
        let viewModelClass = ThemeManager.sharedInstance.currentTheme.streamViewModelClass
        viewModel = viewModelClass.init(stream: stream!, collectionView: collectionView, flowLayoutDelegate: self)
        viewModel?.delegate = self
        collectionView.dataSource = viewModel
        viewModel!.updateCollectionView(true)
    }
    
}
