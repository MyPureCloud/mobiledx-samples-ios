// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Because a custom scene delegate implements this method, UIKit does not automatically
        // instantiate the Main storyboard's initial view controller. Set up the window and the
        // root view controller explicitly from the Main storyboard.
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateInitialViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            if permission.authorizationStatus == .authorized {
                Task { @MainActor in
                    SnackbarView.shared.remove()
                }
            }
        }
    }
}
