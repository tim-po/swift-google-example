//
//  PlaceMarker.swift
//  S_soboy
//
//  Created by Тимофей on 26/09/2018.
//  Copyright © 2018 Тимофей. All rights reserved.
//
import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    // 1
    let place: GooglePlace
    
    // 2
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.placeType+"_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
