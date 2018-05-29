//
//  OpeningMapVC.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa
import RxMKMapView
import SafariServices

class OpeningMapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    let networker: NetworkController!
    let state: StateController!
    let locationManger = CLLocationManager()
    let disposeBag = DisposeBag()
    var firstLocationDisposeBag: DisposeBag? = DisposeBag()
    
    init(networker: NetworkController, state: StateController) {
        self.networker = networker
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.state = StateController()
        self.networker = NetworkController(state: state)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        locationManger.requestWhenInUseAuthorization()
        configureSearchBar()
        configureMapView()
        registerAnnotationViewClasses()
        registerForNotifications()
    }
    
    //these notifications are used to update the UI after we received data back from our network requests
    private func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.placeAnnotations), name: NSNotification.Name(rawValue: "finishedAPICall"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.updateAnnotation), name: NSNotification.Name(rawValue: "annotationImageUpdated"), object: nil)
    }
    
    //register our customer MKAnnotationView classes with the mapView
    private func registerAnnotationViewClasses() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    //configure search bar to subscribed to click events
    private func configureSearchBar() {
        searchBar
            .rx.searchButtonClicked
            .subscribe(onNext: { [unowned self] query in
                self.mapView.removeOverlays(self.mapView.overlays)
                self.searchBar.resignFirstResponder()
                self.mapView.removeAnnotations(self.mapView.annotations)
                let center = self.mapView.centerCoordinate
                if let searchText = self.searchBar.text {
                    //send network request off to network layer
                    let request = NearbyVenueRequest(searchText: searchText, latitude: center.latitude.description, longitude: center.longitude.description)
                    self.networker.getNearbyPlacesFromRequest(request)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //configure mapview to response to different touch events
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        //this adds a gesture recoginzer to the callout view so that we can register a tap on the website subtitle to act like a link
        mapView.rx
            .didSelectAnnotationView
            .asDriver()
            .drive(onNext: { (annotationView) in
                let gesture = UITapGestureRecognizer(target: self, action: #selector(OpeningMapVC.calloutTapped))
                annotationView.addGestureRecognizer(gesture)
            })
            .disposed(by: disposeBag)
        
        //this removes the gesture recofnize from the view when it is deselected so that we don't inadvertently go to the website when clicking on an annotation
        mapView.rx
            .didDeselectAnnotationView
            .asDriver()
            .drive(onNext: { (annotationView) in
                annotationView.gestureRecognizers?.removeAll()
        })
            .disposed(by: disposeBag)
        
        //zoom in on users location when the app launches.  Also we dispose of this as soon as we run the code the first time so we don't keep calling it
        mapView.rx
            .didUpdateUserLocation
            .asDriver()
            .drive(onNext: { (userLocation) in
            let regionRadius = 400000
            let myLocation = userLocation.coordinate
            let coordinateRegion = MKCoordinateRegionMakeWithDistance( myLocation, CLLocationDistance(regionRadius), CLLocationDistance(regionRadius) )
            self.mapView.setRegion( coordinateRegion, animated: true)
            self.firstLocationDisposeBag = nil
        })
            .disposed(by: firstLocationDisposeBag!)
        
        //this fires when a user taps the map icon to draw the directions on the map
        mapView.rx
            .annotationViewCalloutAccessoryControlTapped
            .asDriver()
            .drive(onNext: { (annotationView, control) in
                //the drawing of directions takes time show a waiting indicator during this time
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge, color: .black,  placeInTheCenterOf: self.mapView)
                activityIndicator.startAnimating()
                //remove old directions if they are still there
                self.mapView.removeOverlays(self.mapView.overlays)
                let request = MKDirectionsRequest()
                request.source = MKMapItem.forCurrentLocation()
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: annotationView.annotation!.coordinate))
                request.requestsAlternateRoutes = false
                let directions = MKDirections(request: request)
                //get directions from current location to selected annotation
                directions.calculate(completionHandler: {(response, error) in
                    DispatchQueue.main.async {
                        //stop activity indicator the process is complete
                        activityIndicator.stopAnimating()
                        self.mapView.deselectAnnotation(annotationView.annotation, animated: false)
                    }
                    if error != nil {
                        print("Error getting directions \(error.debugDescription)")
                    } else {
                        //draw the route on the map
                        self.showRoute(response!, mapview: self.mapView, annotation: annotationView.annotation!)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    //this shows the annotations as soon as we get back the first API call
    @objc private func placeAnnotations() {
        if state.searchResults.isEmpty{
            Alert.show("Error", message: "No results found for your search. Please input a different search criteria.", viewController: self)
            return
        }
        mapView.showAnnotations(state.searchResults, animated: true)
    }
    
    //this updates the annotationView after we get back the venue image and website info
    @objc private func updateAnnotation(notification: Notification){
        let venue = state.searchResults.filter{ $0.id == notification.userInfo!["id"] as! String }.first!
            mapView.removeAnnotation(venue)
            mapView.addAnnotation(venue)
    }
    
    //shows the SFSafariViewController with the venue's website if it has one listed
    @objc func calloutTapped(sender:UITapGestureRecognizer) {
        mapView.removeOverlays(mapView.overlays)
        guard let annotation = (sender.view as? MKAnnotationView)?.annotation as? Venue, let urlString = annotation.websiteURL else { return }
        let safariController = SFSafariViewController(url: URL(string: urlString)! )
        self.present(safariController, animated: true, completion: nil)
    }
    
    //show route on mapView
    private func showRoute(_ response: MKDirectionsResponse, mapview: MKMapView, annotation: MKAnnotation) {
        for route in response.routes {
            mapview.add(route.polyline,
                        level: MKOverlayLevel.aboveRoads)
        }
        zoomMapToIncludeRoute(mapView: mapview, annotation: annotation)
    }
    
    //zoom to show the entire route
    private func zoomMapToIncludeRoute(mapView: MKMapView, annotation: MKAnnotation) {
        let userPoint = MKMapPointForCoordinate(mapView.userLocation.coordinate)
        let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
        let userRect = MKMapRect(origin: userPoint, size: MKMapSize(width: 0.0, height: 0.0))
        let annotationRect = MKMapRect(origin: annotationPoint, size: MKMapSize(width: 0.0, height: 0.0))
        let unionRect = MKMapRectUnion(userRect, annotationRect)
        let insets = UIEdgeInsetsMake(50, 50, 50, 50)
        let unionThatFits = mapView.mapRectThatFits(unionRect, edgePadding: insets)
        mapView.setVisibleMapRect(unionThatFits, animated: true)
    }
    
}

extension OpeningMapVC: MKMapViewDelegate{
    
    //this delegate method was unavailabe in RxMKMapView framework
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
}
