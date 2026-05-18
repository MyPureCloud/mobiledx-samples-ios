//
//  PushNotificationService.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 25..
//

import GenesysCloud

actor PushNotificationService {
    private let repository: AccountRepository

    init(repository: AccountRepository) {
        self.repository = repository
    }

    func registerToken(
        deviceToken: String,
        pushProvider: PushProvider,
        account: Account
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            ChatPushNotificationIntegration.setPushToken(deviceToken: deviceToken, pushProvider: pushProvider, account: account) { result in
                continuation.resume(with: result)
            }
        }
    }

    func removePushToken(account: MessengerAccount) async throws {
        try await withCheckedThrowingContinuation { continuation in
            ChatPushNotificationIntegration.removePushToken(account: account) { result in
                continuation.resume(with: result)
            }
        }
    }

    func persistRegistration(
        deploymentId: String?,
        domain: String?
    ) {
        repository.set(pushDeploymentId: deploymentId)
        repository.set(pushDomain: domain)
    }

    func persistPushProvider(pushProvider: PushProvider?, for deploymentId: String) {
        let providerString = pushProvider.map { $0 == .apns ? "apns" : "fcm" }
        repository.set(pushProvider: providerString, for: deploymentId)
    }
}
