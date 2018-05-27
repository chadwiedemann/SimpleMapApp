//
//  OpeningMapVC.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import UIKit
import MapKit

class OpeningMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    let networker: NetworkController!
    let state: StateController!
    var searchBarDelegate: SearchBarDelegate?
    var mapViewDelegate: MapViewDelegate?
    
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
        searchBarDelegate = SearchBarDelegate(searchBar: searchBar, mapView: mapView, stateController: state, networker: networker)
        mapViewDelegate = MapViewDelegate(mapView: mapView, stateController: state, networker: networker)
        registerAnnotationViewClasses()
        //register for notfications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.placeAnnotations), name: NSNotification.Name(rawValue: "finishedAPICall"), object: nil)
    }

    @objc private func placeAnnotations() {
        if state.searchResults.isEmpty{
            Alert.show("Error", message: "no results found for your search request please try another search", viewController: self)
            return
        }
//        mapView.fitAll(in: state.searchResults, andShow: true)
        mapView.showAnnotations(state.searchResults, animated: true)
    }
}

