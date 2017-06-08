//
//  PresetManager.swift
//  Accented
//
//  Pearl FX preset manager
//
//  Created by Tiangong You on 6/4/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class PresetManager: NSObject {
    let availablePresets = [OriginalPhotoPreset(),
                            LookupPreset("Intensify.png"),
                            LookupPreset("CandleLight.png"),
                            LookupPreset("ColorPunchCool.png"),
                            LookupPreset("ColorPunch.png"),
                            LookupPreset("Earthy.png"),
                            LookupPreset("FilmStock.png"),
                            LookupPreset("Lenox.png"),
                            LookupPreset("Remy.png"),
                            LookupPreset("lookup_amatorka.png"),
                            LookupPreset("lookup_miss_etikate.png"),
                            LookupPreset("lookup_soft_elegance_1.png"),
                            LookupPreset("lookup_soft_elegance_1.png")]
}
