//
//  AppDelegate.swift
//  Todoey
//
//  Created by Andrew Spry on 6/5/19.
//  Copyright © 2019 Andrew Spry. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize interface to Realm cloud database.  
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm \(error)")
        }
        // print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
    }

}

