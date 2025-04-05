//
//  AppDelegate.swift
//  RatingControlDemo
//
//  Created by Yonat Sharon on 2025-04-05.
//

import UIKit

@UIApplicationMain
class RatingDemo: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.systemBackground
        window.rootViewController = RatingViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
