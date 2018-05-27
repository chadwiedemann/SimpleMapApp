//
//  SearchBarDelegate.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import UIKit
import MapKit

class SearchBarDelegate: NSObject {
    
    let state: StateController!
    let networker: NetworkController!
    let mapview: MKMapView!
    
    init(searchBar: UISearchBar, mapView: MKMapView, stateController: StateController, networker: NetworkController) {
        self.state = stateController
        self.networker = networker
        self.mapview = mapView
        super.init()
        searchBar.delegate = self
    }
    
}

extension SearchBarDelegate: UISearchBarDelegate{
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        mapview.removeAnnotations(mapview.annotations)
        let center = mapview.centerCoordinate
        if let searchText = searchBar.text {
            networker.getNearbyPlacesFromString(searchText, centerPoint: center)
        }
    }
    
}
