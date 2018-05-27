//
//  StateController.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import UIKit

class StateController {
    var searchResults = [Venue]()
    var imageDictionary = [String:UIImage]()
    
    func loadVenuesFromData(_ data: Data) {
        do{
            let decodedData = try JSONDecoder().decode(SearchResult.self, from: data)
            searchResults = decodedData.response.venues.filter { $0.location.coordinates?.first != nil }
            
            for result in searchResults{
                //we are force unwrapping here becuase we just made sure to remove any nil cases above. 
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
