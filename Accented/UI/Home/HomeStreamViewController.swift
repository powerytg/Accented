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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(appThemeDidChange(_:)), name: ThemeManagerEvents.appThemeDidChange, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createViewModel() {
        viewModel = DefaultViewModel(stream: stream!, collectionView: streamCollectionView, flowLayoutDelegate: self)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            // Section 0 is reserved for stream headers
            return CGSizeZero
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 8)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeZero
        }
        
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 26)
    }
    
    // MARK: - Events
    func appThemeDidChange(notification : NSNotification) {
        viewModel = DefaultViewModel(stream: stream!, collectionView: streamCollectionView, flowLayoutDelegate: self)
        streamCollectionView.dataSource = viewModel
        viewModel!.updateCollectionView(true)
    }
    
}
