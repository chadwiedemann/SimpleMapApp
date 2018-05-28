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

class OpeningMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    let networker: NetworkController!
    let state: StateController!
    var mapViewDelegate: MapViewDelegate?
    let locationManger = CLLocationManager()
    let disposeBag = DisposeBag()
    
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
    
    func registerAnnotationViewClasses() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        locationManger.requestWhenInUseAuthorization()
        subrcibeToSearchFieldTap()
        mapView.showsUserLocation = true
        mapViewDelegate = MapViewDelegate(viewController: self, mapView: mapView, stateController: state, networker: networker)
        registerAnnotationViewClasses()
        //register for notfications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.placeAnnotations), name: NSNotification.Name(rawValue: "finishedAPICall"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.updateAnnotation), name: NSNotification.Name(rawValue: "annotationImageUpdated"), object: nil)
    }

    @objc private func placeAnnotations() {
        if state.searchResults.isEmpty{
            Alert.show("Error", message: "no results found for your search request please try another search", viewController: self)
            return
        }
//        mapView.fitAll(in: state.searchResults, andShow: true)
        mapView.showAnnotations(state.searchResults, animated: true)
    }
    
    @objc private func updateAnnotation(notification: Notification){
        let venue = state.searchResults.filter{ $0.id == notification.userInfo!["id"] as! String }.first!
            mapView.removeAnnotation(venue)
            mapView.addAnnotation(venue)
        
    }
    
    private func subrcibeToSearchFieldTap(){
        searchBar
            .rx.searchButtonClicked
            .subscribe(onNext: { [unowned self] query in
                self.mapView.removeOverlays(self.mapView.overlays)
                self.searchBar.resignFirstResponder()
                self.mapView.removeAnnotations(self.mapView.annotations)
                let center = self.mapView.centerCoordinate
                if let searchText = self.searchBar.text {
                    self.networker.getNearbyPlacesFromString(searchText, centerPoint: center)
                }
            })
            .disposed(by: disposeBag)
    }
}

