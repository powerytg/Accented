//
//  EntranceAnimation.swift
//  Accented
//
//  Created by Tiangong You on 5/20/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol EntranceAnimation : NSObjectProtocol {
    func entranceAnimationWillBegin()
    func performEntranceAnimation()
    func entranceAnimationDidFinish()
}
