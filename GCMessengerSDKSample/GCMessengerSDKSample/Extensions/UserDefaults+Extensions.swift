// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation

extension UserDefaults {
    private enum Keys {
        static let deploymentId = "deploymentId"
        static let domainId = "domainId"
        static let sessionExpirationNoticeInterval = "sessionExpirationNoticeInterval"
        static let token = "token"
        static let logging = "logging"
        static let customAttributes = "customAttributes"
        static let hasOktaCode = "hasOktaCode"
        static let pushNotificationsRegisteredDeployments = "pushNotificationsRegisteredDeployments"
        static let pushDeploymentId = "pushDeploymentId"
        static let pushDomain = "pushDomain"
    }

    class var deploymentId: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.deploymentId) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.deploymentId)
        }
    }
    
    class var domainId: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.domainId) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.domainId)
        }
    }

    class var sessionExpirationNoticeInterval: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.sessionExpirationNoticeInterval) ?? ""
        }

        set {
            UserDefaults.standard.set(newValue, forKey: Keys.sessionExpirationNoticeInterval)
        }
    }

    class var token: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.token) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.token)
        }
    }
    
    class var logging: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.logging)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.logging)
        }
    }
    
    class var customAttributes: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.customAttributes) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.customAttributes)
        }
    }
    
    class var hasOktaCode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOktaCode)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOktaCode)
        }
    }
    
    class func getPushProviderFor(deploymentId: String) -> String? {
        let dict = UserDefaults.standard.dictionary(forKey: Keys.pushNotificationsRegisteredDeployments) as? [String: String]
        return dict?[deploymentId]
    }
    
    class func setPushProviderFor(deploymentId: String, pushProvider: String?) {
        var dict = UserDefaults.standard.dictionary(forKey: Keys.pushNotificationsRegisteredDeployments) as? [String: String] ?? [:]
        dict[deploymentId] = pushProvider
        UserDefaults.standard.set(dict, forKey: Keys.pushNotificationsRegisteredDeployments)
    }
    
    class var pushDeploymentId: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.pushDeploymentId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.pushDeploymentId)
        }
    }
    
    class var pushDomain: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.pushDomain)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.pushDomain)
        }
    }
}
