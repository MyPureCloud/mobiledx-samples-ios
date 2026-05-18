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
    private let toastPresenter = ToastPresenter()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupFirebase()

        Messaging.messaging().delegate = self

        return true
    }

    private func setupFirebase() {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            Logger.error("GoogleService-Info.plist not found")
            return
        }

        guard let plist = NSDictionary(contentsOfFile: path) as? [String: Any],
            let appID = plist["GOOGLE_APP_ID"] as? String,
            !appID.isEmpty
        else {
            Logger.error("GOOGLE_APP_ID not found in GoogleService-Info.plist")
            return
        }

        Logger.info("Firebase configured")
        FirebaseApp.configure()
    }
}

// MARK: Push notifications handling
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let apnsToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Logger.info("Device token registered: \(apnsToken)")
        Messaging.messaging().apnsToken = deviceToken

        NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: nil, userInfo: ["apnsToken": apnsToken])
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: any Error) {
        Logger.error("Remote notification registration failed: \(error.localizedDescription)")

        Task { @MainActor in
            await toastPresenter.present(ToastView(message: "Failed to register: \(error.localizedDescription)"))
        }
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        Logger.info("Push notification received")

        NotificationCenter.default.post(name: Notification.Name.notificationReceived, object: nil, userInfo: userInfo)
        completionHandler(.noData)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { permission in
            Task { @MainActor in
                if permission.authorizationStatus == .authorized {
                    SnackbarView.shared.remove()
                }
            }
        })
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        self.fcmToken = fcmToken

        // Check that Notifications are authorized otherwise there is no need to post any token updates
        UNUserNotificationCenter.current().getNotificationSettings(
            completionHandler: { permission in
                if permission.authorizationStatus == .authorized {
                    Task { @MainActor in
                        NotificationCenter.default.post(
                            name: Notification.Name.deviceTokenReceived,
                            object: nil,
                            userInfo: ["fcmToken": fcmToken as Any]
                        )
                    }
                }
            })
    }

    func registerForAPNsRemoteNotifications() {
        Logger.info("Registering for APNS Push notifications")
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.registerForRemoteNotifications()
    }

    func registerForFCMRemoteNotifications() {
        Logger.info("Registering for FCM Push notifications")
        UNUserNotificationCenter.current().delegate = nil
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.post(name: Notification.Name.deviceTokenReceived, object: nil, userInfo: ["fcmToken": fcmToken as Any])
    }
}
