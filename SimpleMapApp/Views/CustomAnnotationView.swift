//
//  CustomAnnotationView.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    //overiding this so when layoutSubviews is called below we can get a reference to the subtitle so we can set it to blue to represent a hyperlink
    override func didAddSubview(_ subview: UIView) {
        if isSelected {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        if !isSelected {
            return
        }
        //setting thee subtitle with the venue's website to blue
        loopViewHierarchy { (view: UIView) -> Bool in
            if let label = view as? UILabel, let text = label.text, text.contains("http") {
                label.textColor = UIColor.blue
                return false
            }
            return true
        }
    }
    
    //customizing the annotation image and calloutviews here 
    override var annotation: MKAnnotation? {
        willSet {
            if let venue = newValue as? Venue {
                clusteringIdentifier = "vendor"
                image = UIImage(named: "marker.png")
                displayPriority = .defaultHigh
                canShowCallout = true
                leftCalloutAccessoryView = venue.image
                let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
                                                        size: CGSize(width: 35, height: 35)))
                mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Maps-icon"), for: UIControlState())
                rightCalloutAccessoryView = mapsButton
            }
        }
    }
}
