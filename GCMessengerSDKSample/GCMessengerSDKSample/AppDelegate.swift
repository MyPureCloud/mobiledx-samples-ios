// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if (Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil) {
            print("Google Services & Crashlytics enabled")
            FirebaseApp.configure()
        }
        // Override point for customization after application launch.
        return true
    }
}

