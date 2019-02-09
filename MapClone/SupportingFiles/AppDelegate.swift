//
//  AppDelegate.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-07.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):#colorLiteral(red: 0.01194981113, green: 0.4769998789, blue: 0.9994105697, alpha: 1)]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)


        window?.makeKeyAndVisible()
        window?.rootViewController = MapViewController()
        
        return true
    }
}

