//
//  SearchResult.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation

//these two structs are used to help parse the JSON respone we get back from the FourSquareApi in the StateController.
struct SearchResult: Codable {
    let response: Response
}

struct Response: Codable {
    let venues: [DecodableVenue]
}
