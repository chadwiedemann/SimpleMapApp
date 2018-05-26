//
//  Venue.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import CoreLocation

struct Venue: Codable {
    let id: String
    let name: String
    let location: Location
    var coordinates: CLLocationCoordinate2D?
    let photoURL: String?
    let websiteURL: String?
    
    
}
