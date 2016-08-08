//
//  CardAnimation.swift
//  Accented
//
//  Created by Tiangong You on 8/7/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol CardAnimation : NSObjectProtocol {
    func cardDidReceivePanGesture(translation : CGFloat, cardWidth : CGFloat)
    func cardSelectionDidChange(selected : Bool)
    func performCardTransitionAnimation()
}

