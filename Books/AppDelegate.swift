//
//  AppDelegate.swift
//  Books
//
//  Created by Matěj Děcký on 17/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: MainTableViewController(style: .insetGrouped))
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}

