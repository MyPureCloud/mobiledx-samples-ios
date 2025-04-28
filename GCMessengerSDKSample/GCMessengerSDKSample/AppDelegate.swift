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
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    private func setupFirebase() {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            printLog("Can't find GoogleService-Info file", logType: .failure)
            return
        }
        
        guard let plist = NSDictionary(contentsOfFile: path) as? [String: Any],
            let appID = plist["GOOGLE_APP_ID"] as? String,
            !appID.isEmpty
        else {
            printLog("Can't find appID in GoogleService-Info", logType: .failure)
            return
        }

        printLog("✅ Google Services & Crashlytics enabled", logType: .success)
        FirebaseApp.configure()
    }
}

//MARK: Push notifications handling
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        printLog("Device Token: \(apnsToken)")
        
        NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: nil, userInfo: ["apnsToken": apnsToken])
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
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.fcmToken = fcmToken
    }
    
    func registerForFCMRemoteNotifications() {
        NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: nil, userInfo: ["fcmToken": fcmToken as Any])
    }
}
