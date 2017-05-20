//
//  DetailProxyAnimation.swift
//  Accented
//
//  Created by You, Tiangong on 7/27/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DetailEntranceAnimation : EntranceAnimation { }

protocol DetailEntranceProxyAnimation : DetailEntranceAnimation {
    func desitinationRectForProxyView(_ photo : PhotoModel) -> CGRect
}
