//
//  PushNotificationObserver.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 25..
//

import Foundation
import GenesysCloud

@MainActor
final class PushNotificationObserver {
    private var tasks: [Task<Void, Never>] = []

    init(
        onDeviceToken: @escaping (Notification) async -> Void,
        onNotificationReceived: @escaping (Notification) async -> Void
    ) {
        tasks.append(Task { @MainActor in
            for await notification in NotificationCenter.default.notifications(named: .deviceTokenReceived) {
                await onDeviceToken(notification)
            }
        })

        tasks.append(Task { @MainActor in
            for await notification in NotificationCenter.default.notifications(named: .notificationReceived) {
                await onNotificationReceived(notification)
            }
        })
    }

    deinit {
        tasks.forEach { $0.cancel() }
    }
}
