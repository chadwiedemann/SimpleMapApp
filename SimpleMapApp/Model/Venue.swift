//
//  Venue.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class Venue: MKPointAnnotation, Codable {
    let id: String
    let name: String
    let location: Location
    var photoURL: String?
    var websiteURL: String?
    
    init(id: String, name: String, location: Location) {
        self.id = id
        self.name = name
        self.location = location
    }
    
}
