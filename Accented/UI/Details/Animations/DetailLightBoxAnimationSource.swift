//
//  DetailLightBoxAnimationSource.swift
//  Accented
//
//  Created by Tiangong You on 8/9/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol DetailLightBoxAnimationSource : NSObjectProtocol {
    func sourceImageViewForLightBoxTransition() -> UIImageView
}
