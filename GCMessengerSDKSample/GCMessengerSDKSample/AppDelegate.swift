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
        setupFirebase()
        
        Messaging.messaging().delegate = self

        return true
    }
    
    private func setupFirebase() {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            print("Can't find GoogleService-Info file")
            return
        }
        
        guard let plist = NSDictionary(contentsOfFile: path) as? [String: Any],
            let appID = plist["GOOGLE_APP_ID"] as? String,
            !appID.isEmpty
        else {
            print("Can't find appID in GoogleService-Info")
            return
        }

        print("✅ Google Services & Crashlytics enabled")
        FirebaseApp.configure()
    }
}

//MARK: Push notifications handling
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(apnsToken)")
        Messaging.messaging().apnsToken = deviceToken

        NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: nil, userInfo: ["apnsToken": apnsToken])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        print("Failed to register: \(error.localizedDescription)")
        
        ToastManager.shared.showToast(message: "Failed to register: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Push notification received")

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
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.fcmToken = fcmToken
        
        // Check that Notifications are authorized otherwise there is no need to post any token updates
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permission in
            if permission.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: nil, userInfo: ["fcmToken": fcmToken as Any])
                }
            }
        })
    }
    
    func registerForAPNsRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func registerForFCMRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = nil
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: nil, userInfo: ["fcmToken": fcmToken as Any])
    }
}
