//
//  CustomAnnotationView.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
                clusteringIdentifier = "vendor"
                image = UIImage(named: "marker.png")
                displayPriority = .defaultHigh
                canShowCallout = true
                
        }
    }
    
}
