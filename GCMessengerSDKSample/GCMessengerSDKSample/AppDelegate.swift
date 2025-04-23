// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import FirebaseCore
import UserNotifications
import GenesysCloudCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var fcmToken: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path) as? [String: Any],
           let appID = plist["GOOGLE_APP_ID"] as? String,
           !appID.isEmpty {
            print("Google Services & Crashlytics enabled")
            FirebaseApp.configure()
        }
        
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
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
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permission in
            
            DispatchQueue.main.async {
                if permission.authorizationStatus == .authorized {
                    SnackbarView.shared.remove()
                }
            }
        })
    }
}
