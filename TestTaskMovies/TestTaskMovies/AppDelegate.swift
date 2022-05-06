//
//  AppDelegate.swift
//  TestTaskMovies
//
//  Created by Natalia on 04.05.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let rootVC = MainViewController()
        self.window?.rootViewController = UINavigationController(rootViewController: rootVC)
        self.window?.makeKeyAndVisible()
        return true
    }
}

