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
    
    var pushDeviceToken: String?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if (Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil) {
            print("Google Services & Crashlytics enabled")
            FirebaseApp.configure()
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permission for push notifications denied.")
            }
        }
        
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let pushDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(pushDeviceToken)")
        
        self.pushDeviceToken = pushDeviceToken
    }
    
    // Handling incoming notifications when app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification and perform necessary actions
        completionHandler()
    }
}

