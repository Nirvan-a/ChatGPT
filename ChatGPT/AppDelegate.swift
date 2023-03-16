//
//  AppDelegate.swift
//  ChatGPT
//
//  Created by nirvana on 3/5/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ChatGPTMainViewController()
        window?.makeKeyAndVisible()
        return true
    }
        
}

