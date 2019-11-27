//
//  AppDelegate.swift
//  financial-control
//
//  Created by Livia Vasconcelos on 03/11/19.
//  Copyright © 2019 Livia Vasconcelos. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainView: SignInViewController = SignInViewController()
                
        let navigation = UINavigationController(rootViewController: mainView)
        
        navigation.navigationBar.topItem?.title                 = "Passivos"
        navigation.navigationBar.prefersLargeTitles             = true
        navigation.navigationBar.topItem?.largeTitleDisplayMode = .automatic
        navigation.navigationBar.largeTitleTextAttributes       = [.foregroundColor: UIColor.black]
        navigation.navigationBar.titleTextAttributes            = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor       = .black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)
        window                     = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = navigation
        window!.makeKeyAndVisible()
        
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5996338232625365~3987246626")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }


}



