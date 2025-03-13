// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import FirebaseCore
import UserNotifications
import GenesysCloudCore

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

//MARK: Push notifications handling
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let pushDeviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        printLog("Device Token: \(pushDeviceToken)")
        
        NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: pushDeviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        printLog("Failed to register: \(error.localizedDescription)", logType: .failure)
        
        ToastManager.shared.showToast(message: "Failed to register: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        printLog("Push notification received")

        NotificationCenter.default.post(name: Notification.Name.notificationReceived, object: nil, userInfo: userInfo)
        completionHandler(.noData)
    }
}
