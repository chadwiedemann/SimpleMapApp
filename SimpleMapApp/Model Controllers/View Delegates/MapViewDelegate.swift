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
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let annotationIdentifier = "AnnotationIdentifier"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            annotationView!.canShowCallout = false
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//        let pinImage = UIImage(named: "marker.png")
//        annotationView!.image = pinImage
//        annotationView?.clusteringIdentifier = "clusterID"
//        return annotationView
//    }
//    
//    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//        let test = MKClusterAnnotation(memberAnnotations: memberAnnotations)
//        test.title = String(memberAnnotations.count)
//        test.subtitle = nil
//        
//        return test
//    }
}
