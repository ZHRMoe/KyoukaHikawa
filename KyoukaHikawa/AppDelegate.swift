//
//  AppDelegate.swift
//  KyoukaHikawa
//
//  Created by ZHRMoe on 2020/7/31.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Never Insert
        if #available(iOS 10, *) {
            UICollectionView.appearance().isPrefetchingEnabled = false
        }
        if #available(iOS 11, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        
        /// Network
        KHNetwork.shared.requestDefaultData()
        
        /// Record First Launch
        if let _ = UserDefaults.standard.object(forKey: "kFirstLaunchDate") as? Date {
            
        } else {
            let curDate = Date()
            UserDefaults.standard.set(curDate, forKey: "kFirstLaunchDate")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

