//
//  Location.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import CoreLocation

struct Location: Codable {
    let coordinates: CLLocationCoordinate2D
    let city: String
    let address: String
    let distance: Int
    
    enum CodingKeys: String, CodingKey {
        case coordinates = "labeledLatLngs"
        case city = "city"
        case address = "address"
        case distance = "distance"
    }
    
}
