//
//  DetailLightBoxAnimation.swift
//  Accented
//
//  Created by Tiangong You on 8/9/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DetailLightBoxAnimation : NSObjectProtocol {
    func lightBoxTransitionWillBegin()
    func performLightBoxTransition()
    func lightboxTransitionDidFinish()
    func desitinationRectForSelectedLightBoxPhoto(_ photo : PhotoModel) -> CGRect
}

