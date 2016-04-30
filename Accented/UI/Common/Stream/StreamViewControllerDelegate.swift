//
//  StreamViewControllerDelegate.swift
//  Accented
//
//  Created by Tiangong You on 4/29/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol StreamViewControllerDelegate {
    func streamViewDidFinishedScrolling(firstVisiblePhoto: PhotoModel);
}
