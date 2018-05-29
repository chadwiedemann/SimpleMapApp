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

class Venue: NSObject, MKAnnotation {
    
    let id: String
    let name: String
    let location: Location
    var photoURL: String?
    var websiteURL: String?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImageView?
    var subtitle: String?
    
    init(decodableVenue: DecodableVenue) {
        self.id = decodableVenue.id
        self.name = decodableVenue.name
        self.location = decodableVenue.location
        self.subtitle = websiteURL
        self.coordinate = decodableVenue.coordinate ?? CLLocationCoordinate2D()
    }
}

//we need this class because MKAnnotations must not have optional coordinates per the protol requirements but the data we get back from FourSquare is occasionally missing coordinate data. this class has an optional coordinate property and the normal Venue class does not.  
class DecodableVenue: NSObject, Codable {
    let id: String
    let name: String
    let location: Location
    var photoURL: String?
    var websiteURL: String?
    var coordinate: CLLocationCoordinate2D?
    var title: String?
    
    init(id: String, name: String, location: Location) {
        self.id = id
        self.name = name
        self.location = location
        self.coordinate = CLLocationCoordinate2D()
    }
}
