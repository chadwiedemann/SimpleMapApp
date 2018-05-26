//
//  URLs.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation

struct URLs {
    static let searchVenuesURL = "https://api.foursquare.com/v2/venues/search"
    static func venueDetailsURLFromVenueID(_ id: String) -> String{
        return "https://api.foursquare.com/v2/venues/" + id
    }
}

