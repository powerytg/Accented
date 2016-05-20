//
//  StreamViewControllerDelegate.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol StreamViewControllerDelegate : NSObjectProtocol {
    func streamViewDidFinishedScrolling(firstVisiblePhoto: PhotoModel)
    func streamViewContentOffsetDidChange(contentOffset : CGFloat)
}
