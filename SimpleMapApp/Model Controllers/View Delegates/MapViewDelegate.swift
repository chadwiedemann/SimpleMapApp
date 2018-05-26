//
//  MapViewDelegate.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import MapKit

class MapViewDelegate: NSObject {
    
    let state: StateController!
    let networker: NetworkController!
    
    init(mapView: MKMapView, stateController: StateController, networker: NetworkController) {
        self.state = stateController
        self.networker = networker
        super.init()
        mapView.delegate = self
    }
    
}

extension MapViewDelegate: MKMapViewDelegate{
    
}
