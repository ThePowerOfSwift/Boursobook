//
//  AppDelegate.swift
//  Boursobook
//
//  Created by David Dubez on 12/06/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    override init() {

        // Select FireBase dataBase depending of testing or production mode
        guard let developmentPath = Bundle.main.path(forResource: "GoogleService-Info-development",
                                               ofType: "plist") else {return}
        guard let productionPath = Bundle.main.path(forResource: "GoogleService-Info-production",
                                               ofType: "plist") else {return}
        var plistPath = productionPath

            #if TEST_VERSION
            // select testDatabase for scheme for test
            print("Running DEVELOPMENT_VERSION")
            print("Using https://boursobookfortests.firebaseio.com ")
            plistPath = developmentPath

            #else
            // select productionDatabase for scheme for production
            print("Running PRODUCTION_VERSION")
            print("Using https://boursobook.firebaseio.com ")
            plistPath = productionPath
            #endif

        if let option = FirebaseOptions(contentsOfFile: plistPath) {
            FirebaseApp.configure(options: option)
        }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks.
        //Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information
        // to restore your application to its current state in case it is terminated later.
        // If your application supports background execution,
        // this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state;
        //here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive.
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

}
