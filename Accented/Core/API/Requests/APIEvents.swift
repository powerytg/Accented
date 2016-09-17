//
//  APIEvents.swift
//  Accented
//
//  Created by You, Tiangong on 9/16/16.
//  Copyright © 2016 Tiangong You. All rights reserved.
//

import UIKit

class APIEvents: NSObject {

    static let streamPhotosDidReturn = Notification.Name("streamPhotosDidReturn")
    
    static let streamPhotosFailedReturn = Notification.Name("streamPhotosFailedReturn")
}
