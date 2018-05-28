//
//  SearchResult.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
struct SearchResult: Codable {
    let response: Response

}

struct Response: Codable {
    let venues: [DecodableVenue]
}

