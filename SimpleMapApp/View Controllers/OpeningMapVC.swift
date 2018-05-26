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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarDelegate = SearchBarDelegate(searchBar: searchBar, mapView: mapView, stateController: state, networker: networker)
        mapViewDelegate = MapViewDelegate(mapView: mapView, stateController: state, networker: networker)
    }

}

