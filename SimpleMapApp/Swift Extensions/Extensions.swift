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

extension UIActivityIndicatorView {
    
    convenience init(activityIndicatorStyle: UIActivityIndicatorViewStyle, color: UIColor, placeInTheCenterOf parentView: UIView) {
        self.init(activityIndicatorStyle: activityIndicatorStyle)
        center = parentView.center
        self.color = color
        parentView.addSubview(self)
    }
}

extension UIView {
    func loopViewHierarchy(block: ViewBlock?) {
        
        if block?(self) ?? true {
            for subview in subviews {
                subview.loopViewHierarchy(block: block)
            }
        }
    }
}

extension String {
    func indexDistance(of character: Character) -> Int? {
        guard let index = index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
}

//extension MKMapView {
//    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
//    func fitAll() {
//        var zoomRect  = MKMapRectNull;
//        for annotation in annotations {
//            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
//            let pointRect       = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.01, 0.01);
//            zoomRect = MKMapRectUnion(zoomRect, pointRect);
//        }
//        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(100, 100, 100, 100), animated: true)
//    }
//
//    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
//    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
//        var zoomRect:MKMapRect  = MKMapRectNull
//
//        for annotation in annotations {
//            let aPoint          = MKMapPointForCoordinate(annotation.coordinate)
//            let rect            = MKMapRectMake(aPoint.x, aPoint.y, 0.1, 0.1)
//
//            if MKMapRectIsNull(zoomRect) {
//                zoomRect = rect
//            } else {
//                zoomRect = MKMapRectUnion(zoomRect, rect)
//            }
//        }
//        if(show) {
//            addAnnotations(annotations)
//        }
//        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
//    }
//
//}

