//
//  CafeGMSMarker.swift
//  S_soboy
//
//  Created by Тимофей on 18/10/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//

import UIKit
import GoogleMaps

class CafeGMSMarker: GMSMarker {
    var cafe: Cafe
    var alreadyEvBeenTaped = false
    
    init(withCafe cafe: Cafe, withCoordinates coordinates: CLLocationCoordinate2D) {
        self.cafe = cafe
        super.init()
        position = coordinates
    }
}
