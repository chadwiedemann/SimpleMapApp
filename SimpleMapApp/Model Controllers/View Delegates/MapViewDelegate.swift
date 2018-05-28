//
//  MapViewDelegate.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import SafariServices

class MapViewDelegate: NSObject {
    
    let state: StateController!
    let networker: NetworkController!
    var myRoute: MKRoute?
    let viewController: UIViewController!
    let myMapView: MKMapView!
    
    init(viewController: UIViewController, mapView: MKMapView, stateController: StateController, networker: NetworkController) {
        self.state = stateController
        self.networker = networker
        self.viewController = viewController
        self.myMapView = mapView
        super.init()
        mapView.delegate = self
    }
    
}

extension MapViewDelegate: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
//        view.gestureRecognizers?.removeAll()
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .black,  placeInTheCenterOf: mapView)
        activityIndicator.startAnimating()
        //show map directions to current location
        mapView.removeOverlays(mapView.overlays)
        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: view.annotation!.coordinate))
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
            }
            
            if error != nil {
                print("Error getting directions \(error.debugDescription)")
            } else {
                self.showRoute(response!, mapview: mapView, annotation: view.annotation!)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func showRoute(_ response: MKDirectionsResponse, mapview: MKMapView, annotation: MKAnnotation) {
        for route in response.routes {
            mapview.add(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
        }
        zoomMapToIncludeRoute(mapView: mapview, annotation: annotation)
    }
    
    func zoomMapToIncludeRoute(mapView: MKMapView, annotation: MKAnnotation) {
        let userPoint = MKMapPointForCoordinate(mapView.userLocation.coordinate)
        let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
        let userRect = MKMapRect(origin: userPoint, size: MKMapSize(width: 0.0, height: 0.0))
        let annotationRect = MKMapRect(origin: annotationPoint, size: MKMapSize(width: 0.0, height: 0.0))
        let unionRect = MKMapRectUnion(userRect, annotationRect)
        let insets = UIEdgeInsetsMake(50, 50, 50, 50)
        let unionThatFits = mapView.mapRectThatFits(unionRect, edgePadding: insets)
        mapView.setVisibleMapRect(unionThatFits, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(MapViewDelegate.calloutTapped))
        view.addGestureRecognizer(gesture)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.gestureRecognizers?.removeAll()
    }
    
    
    @objc func calloutTapped(sender:UITapGestureRecognizer) {
        myMapView.removeOverlays(myMapView.overlays)
        guard let annotation = (sender.view as? MKAnnotationView)?.annotation as? Venue, let urlString = annotation.websiteURL else { return }
        let safariController = SFSafariViewController(url: URL(string: urlString)! )
        viewController.present(safariController, animated: true, completion: nil)
//        sender.view?.gestureRecognizers?.removeAll()
    }
    
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        
//        
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//            annotationView!.canShowCallout = true
//        }
//        else {
//            annotationView!.annotation = annotation
//        }
//        if !annotation.isKind(of: MKClusterAnnotation.self){
//            let customAnnotation = annotation as! Venue
//            annotationView?.leftCalloutAccessoryView = UIImageView(image: state.imageDictionary[customAnnotation.id])
//        }
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
