//
//  AppDelegate.swift
//  SimpleMapApp
//
//  Created by Chad Wiedemann on 5/26/18.
//  Copyright © 2018 Chad Wiedemann LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Injecting our StateController and NetworkController early on in the app's lifecycle.  We will pass this along to other classes as needed.
        let stateController = StateController()
        let networkController = NetworkController(state: stateController)
        let controller = OpeningMapVC(networker: networkController, state: stateController)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = controller
        return true
    }
}
