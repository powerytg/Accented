//
//  InfiniteLoadingViewControllerDelegate.swift
//  Accented
//
//  Created by You, Tiangong on 10/21/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol InfiniteLoadingViewControllerDelegate : NSObjectProtocol {
    func collectionViewContentOffsetDidChange(_ contentOffset : CGFloat)
}
