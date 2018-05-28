//
//  NetworkController.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import MapKit
import RxCocoa
import RxSwift

class NetworkController {
    
    let state: StateController!
    
    
    init(state: StateController) {
        self.state = state
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.getVenueDetailsFromAPI), name: NSNotification.Name(rawValue: "finishedAPICall"), object: nil)
    }
    
    func getNearbyPlacesFromString(_ searchValue: String, centerPoint: CLLocationCoordinate2D) {
        var url = URLComponents(string: URLs.searchVenuesURL)!
        print("\(centerPoint.latitude.description),\(centerPoint.longitude.description)")
        url.queryItems = [
            URLQueryItem(name: "ll", value: "\(centerPoint.latitude.description),\(centerPoint.longitude.description)"),
            URLQueryItem(name: "intent", value: "browse"),
            URLQueryItem(name: "radius", value: "100000"),
            URLQueryItem(name: "query", value: searchValue),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "client_id", value: FourSquareCodes.fourSquareClientID),
            URLQueryItem(name: "client_secret", value: FourSquareCodes.fourSquareClientSecret),
            URLQueryItem(name: "v", value: "20180524")
        ]
        
        url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: url.url!)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let myData = data else{
                return
            }
            self.state.loadVenuesFromData(myData)
        }
        task.resume()
    }
    
    @objc func getVenueDetailsFromAPI(){
        for venue in state.searchResults{
            var url = URLComponents(string: URLs.venueDetailsURLFromVenueID(venue.id))!
            url.queryItems = [
                URLQueryItem(name: "client_id", value: FourSquareCodes.fourSquareClientID),
                URLQueryItem(name: "client_secret", value: FourSquareCodes.fourSquareClientSecret),
                URLQueryItem(name: "v", value: "20180524")
            ]
            
            url.percentEncodedQuery = url.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            let request = URLRequest(url: url.url!)
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                do {
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let reponseDic = json["response"] as? [String: Any],
                        let venueDetail = reponseDic["venue"] as? [String: Any]{
                        print(json)
                        if let websiteURL = venueDetail["url"] as? String {
                            venue.websiteURL = websiteURL
                            venue.subtitle = websiteURL
                        }
                        if let bestPhoto = venueDetail["bestPhoto"] as? [String: Any],
                            let prefix = bestPhoto["prefix"] as? String,
                            let suffix = bestPhoto["suffix"] as? String{
                            venue.photoURL = prefix + "36x36" + suffix
                            self.downloadVenuePhoto(venue)
                        }
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                }
            }
            task.resume()
        }
    }
    
    func downloadVenuePhoto(_ venue: Venue) {
        print("photo download started \(venue.photoURL ?? "NO IMAGE")")
        guard let websiteURL = venue.photoURL else {
            return
        }
        let url = URL(string: websiteURL)!
        URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let newImage = UIImage(data: data) else {
                    return
                }
            DispatchQueue.main.async {
                venue.image = UIImageView(image: newImage)
                let notificationCenter = NotificationCenter.default
                let info = ["id": venue.id]
                notificationCenter.post(name: NSNotification.Name(rawValue: "annotationImageUpdated"), object: nil, userInfo: info)
            }
            
                print("IMAGE CACHED")
        }.resume()
    }
}
