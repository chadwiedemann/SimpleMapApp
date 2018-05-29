//
//  StateController.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class StateController {
    
    var searchResults = [Venue]()
    
    func loadVenuesFromData(_ data: Data) {
        do{
            //parse API data
            let decodedData = try JSONDecoder().decode(SearchResult.self, from: data)
            //sometimes the 4Square API returns empty data for coordinates.  we need to filter out results that don't have coordinates
            searchResults = decodedData.response.venues.filter { $0.location.coordinates?.first != nil }.map{ Venue(decodableVenue: $0) }
            for result in searchResults{
                //we are force unwrapping here becuase we just made sure to remove any records with nil coordinates above.
                result.coordinate = result.location.coordinates!.first!
                result.title = result.name                
            }
            //load annotations onto map and zoom in to fit them
            DispatchQueue.main.async {
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: NSNotification.Name(rawValue: "finishedAPICall"), object: nil)
            }
        }catch{
            //handle error situation
            print(error)
        }
    }
}
