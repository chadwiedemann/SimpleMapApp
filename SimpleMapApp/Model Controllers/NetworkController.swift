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
    
    //this network call gets all the nearby locations that fit our search term
    func getNearbyPlacesFromRequest(_ request: APIRequest) {
        let searchRequest = request.request(with: URL(string: AppStrings.fourSquareBaseURL)!)
        let task = URLSession.shared.dataTask(with: searchRequest) {(data, response, error) in
            guard let myData = data else{
                return
            }
            //after we get data load that data into memory in our StateController
            self.state.loadVenuesFromData(myData)
        }
        task.resume()
    }
    
    //this is called after we get back a list of venues we want to download the details such as website and most popular image URL for each location
    @objc func getVenueDetailsFromAPI(){
        //making this call for all the results
        for venue in state.searchResults{
            let apiRequest = VenueDetailRequest(venueID: venue.id)
            let detailRequest = apiRequest.request(with: URL(string: AppStrings.fourSquareBaseURL)!)
            let task = URLSession.shared.dataTask(with: detailRequest) {(data, response, error) in
                do {
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let reponseDic = json["response"] as? [String: Any],
                        let venueDetail = reponseDic["venue"] as? [String: Any]{
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
    
    //this dataTask downloads the image from the URL we got from the detials API call
    func downloadVenuePhoto(_ venue: Venue) {
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
        }.resume()
    }
}
