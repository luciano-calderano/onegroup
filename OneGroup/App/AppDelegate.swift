//
//  AppDelegate.swift
//  OneGroup
//
//  Created by Developer on 31/07/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        getSponsor()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        getSponsor()
    }
    
    private func getSponsor () {
        do {
            let data = try Data(contentsOf: Config.Url.sponsor!)
            try data.write(to: Config.Url.sponsorFile)
        }
        catch {
            print("errore sponsor")
        }
    }
}

