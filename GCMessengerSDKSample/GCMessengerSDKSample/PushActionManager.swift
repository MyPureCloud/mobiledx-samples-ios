//
//  PushActionManager.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2025. 10. 06..
//
import UIKit
import UserNotifications
@preconcurrency import Combine
@preconcurrency import GenesysCloud

final class PushActionManager: Sendable {
    let pushNotificationViewSubject = PassthroughSubject<Void, Never>()
    let snackbarViewSubject = PassthroughSubject<Void, Never>()
    let toastSubject = PassthroughSubject<String, Never>()
    let errorSubject = PassthroughSubject<AccountDetailsError, Never>()

    func checkNotificationAuthStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] permission in
            guard let self, permission.authorizationStatus != .authorized else { return }

            Task { @MainActor in
                self.snackbarViewSubject.send()
            }
        }
    }

    @MainActor
    func registerForPushNotifications(pushProvider: PushProvider) async {
        do {
            try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            printLog("Register for remote notifications")
            switch pushProvider {
            case .apns:
                appDelegate.registerForAPNsRemoteNotifications()
            case .fcm:
                appDelegate.registerForFCMRemoteNotifications()
            default:
                break
            }
        } catch {
            printLog("Notifications Disabled")
            errorSubject.send(.pushDisabled)
        }
    }

    func removeFromPushNotifications(
        account: MessengerAccount?,
        deploymentId: String?
    ) {
        guard let account else { return }
        ChatPushNotificationIntegration.removePushToken(account: account) { [weak self] error in
            if let error {
                self?.errorSubject.send(.error(error: error))
            }

            guard let deploymentId else {
                NSLog("Can't get deployment ID")
                return
            }

            UserDefaults.setPushProviderFor(deploymentId: deploymentId, pushProvider: nil)
            UserDefaults.pushDeploymentId = nil
            UserDefaults.pushDomain = nil

            self?.toastSubject.send("Push Notifications are DISABLED")
        }
    }

    @objc func handleDeviceToken(
        pushProvider: PushProvider,
        account: Account?,
        deviceToken: String?,
        deploymentId: String?,
        domain: String?
    ) {
        guard let account, let deviceToken else {
            NSLog("Error: push provider selection error")
            return
        }

        ChatPushNotificationIntegration.setPushToken(
            deviceToken: deviceToken,
            pushProvider: pushProvider,
            account: account
        ) { [weak self] result in
            guard let self else { return }

            guard let deploymentId, let domain else {
                NSLog("Can't get deployment ID or domain")
                return
            }

            switch result {
            case .success:
                self.setRegistrationFor(deploymentId: deploymentId, pushProvider: pushProvider)
                UserDefaults.pushDeploymentId = deploymentId
                UserDefaults.pushDomain = domain
                NSLog("\(pushProvider) was registered with device token \(deviceToken)")
            case .failure(let error):
                let errorText = error.errorDescription ?? String(describing: error.errorType)
                if errorText == "Device already registered." {
                    self.setRegistrationFor(deploymentId: deploymentId, pushProvider: pushProvider)
                }
                self.errorSubject.send(.error(error: error))
            }
        }
    }

    func setRegistrationFor(deploymentId: String, pushProvider: GenesysCloud.PushProvider) {
        let pushProviderString = pushProvider == .apns ? "apns" : "fcm"
        UserDefaults.setPushProviderFor(deploymentId: deploymentId, pushProvider: pushProviderString)
        pushNotificationViewSubject.send()
    }

    @MainActor
    func showPushSnackbar() {
        guard let view = UIApplication.getTopViewController()?.view else { return }

        SnackbarView.shared.show(
            topAnchorView: view,
            message: "Notifications are disabled",
            title: "Settings",
            onButtonTap: openAppSettings,
            onCloseTap: removeSnackbar)
    }

    @MainActor
    func removeSnackbar() { SnackbarView.shared.remove() }

    @MainActor
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
