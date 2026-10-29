//
//  PushNotificationService.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 25..
//

import GenesysCloud

@MainActor
final class PushNotificationService {
    private let repository: AccountRepository

    init(repository: AccountRepository) {
        self.repository = repository
    }

    // The SDK calls these completions on a background thread. They must stay @Sendable:
    // a MainActor-isolated closure traps at runtime under Swift 6 when called off the main thread.
    func registerToken(
        deviceToken: String,
        pushProvider: PushProvider,
        account: Account
    ) async throws {
        try await withCheckedThrowingContinuation { continuation in
            ChatPushNotificationIntegration.setPushToken(
                deviceToken: deviceToken,
                pushProvider: pushProvider,
                account: account
            ) { @Sendable result in
                continuation.resume(with: result)
            }
        }
    }

    func removePushToken(account: MessengerAccount) async throws {
        try await withCheckedThrowingContinuation { continuation in
            ChatPushNotificationIntegration.removePushToken(account: account) { @Sendable (result: Result<Void, GCError>) in
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
