//
//  Alert.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    static func show(_ title: String, message: String, viewController: UIViewController, okayCompletion: (()->())? = nil, cancelCompletion: (()->())? = nil) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            //add the action with completion or just the okay button
            if let okayCompletion = okayCompletion, let cancelCompletion = cancelCompletion {//add okay action if we have one
                let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                    okayCompletion()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
                    cancelCompletion()
                }
                alert.addAction(okayAction)
                alert.addAction(cancelAction)
            }else{//just add an okay button
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alert) in
                    
                })
                alert.addAction(alertAction)
            }
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
