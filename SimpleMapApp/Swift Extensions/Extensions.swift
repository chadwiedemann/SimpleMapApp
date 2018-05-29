//
//  Extensions.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import MapKit

typealias ViewBlock = (_ view: UIView) -> Bool

//making CLLocationCoordinate2D conform to Coadable so we can Parse the API JSON more easily
extension CLLocationCoordinate2D: Codable {
    
    public enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
    }
    
}

extension UIViewController {
    
    //hides the keyboard when user presses on the main view
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //dismisses keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//a convenience initilizer to make showing the Activity Indicator easier
extension UIActivityIndicatorView {
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(activityIndicatorStyle: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}

extension UIView {
    //use this to help loop through the views of the MKAnnotationView callout when changing its text to blue
    func loopViewHierarchy(block: ViewBlock?) {
        if block?(self) ?? true {
            for subview in subviews {
                subview.loopViewHierarchy(block: block)
            }
        }
    }
}

extension MKMapView{
    func zoomIn(coordinate: CLLocationCoordinate2D, withLevel level:CLLocationDistance = 10000){
        let camera =
            MKMapCamera(lookingAtCenter: coordinate, fromEyeCoordinate: coordinate, eyeAltitude: level)
        self.setCamera(camera, animated: true)
    }
}
