//
//  NetworkController.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import MapKit

class NetworkController {
    
    let state: StateController!
    
    init(state: StateController) {
        self.state = state
    }
    
    func getNearbyPlacesFromString(_ searchValue: String, centerPoint: CLLocationCoordinate2D) {
        var url = URLComponents(string: URLs.searchVenuesURL)!
        print("\(centerPoint.latitude.description),\(centerPoint.longitude.description)")
        url.queryItems = [
            URLQueryItem(name: "ll", value: "\(centerPoint.latitude.description),\(centerPoint.longitude.description)"),
            URLQueryItem(name: "intent", value: "browse"),
            URLQueryItem(name: "radius", value: "16000"),
            URLQueryItem(name: "query", value: searchValue),
            URLQueryItem(name: "limit", value: "20"),
            URLQueryItem(name: "client_id", value: FourSquareCodes.fourSquareClientID),
            URLQueryItem(name: "client_secret", value: FourSquareCodes.fourSquareClientSecret),
            URLQueryItem(name: "v", value: "20180524")
        ]
        
        url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: url.url!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let mydata = data else{
                return
            }
            let jsondata = try! JSONSerialization.jsonObject(with: mydata, options: [])
            print(jsondata)
            
            
        }
        task.resume()
        
        
        
    }
    
}
