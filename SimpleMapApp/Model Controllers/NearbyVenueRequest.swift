//
//  VenueRequest.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/28/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation

class NearbyVenueRequest: APIRequest {
    
    var method = RequestType.GET
    var path = "search"
    var parameters = [String: String]()
    
    init(searchText: String, latitude: String, longitude: String) {
        parameters["ll"] = "\(latitude),\(longitude)"
        parameters["intent"] = "browse"
        parameters["limit"] = "10"
        parameters["radius"] = "100000"
        parameters["query"] = searchText
        parameters["client_id"] = FourSquareCodes.fourSquareClientID
        parameters["client_secret"] = FourSquareCodes.fourSquareClientSecret
        parameters["v"] = "20180524"
    }
}
