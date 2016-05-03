//
//  GatewayStreamViewController.swift
//  Accented
//
//  Created by Tiangong You on 5/2/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class GatewayStreamViewController: StreamViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func createViewModel() {
        viewModel = GatewayViewModel(stream: stream!, collectionView: streamCollectionView, flowLayoutDelegate: self)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 290)
        } else {
            return CGSizeMake(CGRectGetWidth(collectionView.bounds), 8)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 26)
    }
}
