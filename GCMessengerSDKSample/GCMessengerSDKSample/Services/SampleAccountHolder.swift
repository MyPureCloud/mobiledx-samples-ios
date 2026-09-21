// ===================================================================================================
// Copyright © 2026 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import GenesysCloudMessenger

/// Process-wide holder for the single `MessengerAccount` instance the sample app currently operates
/// on. Chat, availability, push and tracking actions all reuse this same instance instead of
/// building a brand new `MessengerAccount` on every action, so mutable state such as the active
/// tracker, journey identity and auth info stays consistent across screens.
///
/// A new instance is only created when the deployment id or domain actually changes, since that
/// represents a genuinely different account.
@MainActor
final class SampleAccountHolder {
    static let shared = SampleAccountHolder()

    private(set) var account: MessengerAccount?

    // `MessengerAccount.deploymentId` is internal to GenesysCloudMessenger, unlike `domain`
    // (public), so only deploymentId needs tracking here to detect an identity change.
    private var deploymentId: String?

    private init() {}

    /// Returns the current `MessengerAccount` when it already targets `deploymentId`/`domain`.
    /// Builds and stores a new instance (replacing any previous one) when the deployment id or
    /// domain don't match, or when none exists yet. `logging`/`sessionExpirationNoticeInterval`
    /// only apply when a new instance is built, since `MessengerAccount` doesn't expose either as
    /// mutable from outside the SDK module.
    func getOrUpdate(
        deploymentId: String,
        domain: String,
        logging: Bool,
        sessionExpirationNoticeInterval: Int
    ) -> MessengerAccount {
        if let current = account, self.deploymentId == deploymentId, current.domain == domain {
            return current
        }

        let target = MessengerAccount(
            deploymentId: deploymentId,
            domain: domain,
            logging: logging,
            sessionExpirationNoticeInterval: sessionExpirationNoticeInterval
        )
        account = target
        self.deploymentId = deploymentId
        return target
    }

    func clear() {
        account = nil
        deploymentId = nil
    }
}
