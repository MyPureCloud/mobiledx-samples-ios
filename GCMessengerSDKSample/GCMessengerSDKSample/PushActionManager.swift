//
//  PushActionManager.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2025. 10. 06..
//

import UserNotifications
import UIKit

@MainActor
final class PushActionManager: Sendable {
    func checkNotificationAuthStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] permission in
            guard let self else { return }

            if permission.authorizationStatus != .authorized {
                Task { @MainActor in
                    self.showPushSnackbar()
                }
            }
        }
    }

    func showPushSnackbar() {
        guard let view = UIApplication.getTopViewController()?.view else { return }

        SnackbarView.shared.show(
            topAnchorView: view,
            message: "Notifications are disabled",
            title: "Settings",
            onButtonTap: self.openAppSettings,
            onCloseTap: self.removeSnackbar)
    }

    func removeSnackbar() { SnackbarView.shared.remove() }

    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
