//
//  VenueDetailRequest.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/28/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation

class VenueDetailRequest: APIRequest {
    
    var method = RequestType.GET
    var path = ""
    var parameters = [String: String]()
    
    init(venueID: String) {
        parameters["client_id"] = FourSquareCodes.fourSquareClientID
        parameters["client_secret"] = FourSquareCodes.fourSquareClientSecret
        parameters["v"] = "20180524"
        self.path = venueID
    }
    
}
