//
//  StreamLayoutTemplate.swift
//  Accented
//
//  Created by Tiangong You on 5/1/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

protocol StreamLayoutTemplate {
    // Fixed, calculated height
    var height : CGFloat { get }
    
    // Generated layout frames
    var frames : Array<CGRect> { get }
}
