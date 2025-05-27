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
        static let token = "token"
        static let logging = "logging"
        static let customAttributes = "customAttributes"
        static let pushNotificationsRegisteredDeployments = "pushNotificationsRegisteredDeployments"
        static let savedPushDeploymentId = "savedPushDeploymentId"
        static let savedPushDomain = "savedPushDomain"
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
    
    class func getPushProviderFor(deploymentId: String) -> String? {
        let dict = UserDefaults.standard.dictionary(forKey: Keys.pushNotificationsRegisteredDeployments) as? [String: String]
        return dict?[deploymentId]
    }
    
    class func setPushProviderFor(deploymentId: String, pushProvider: String?) {
        var dict = UserDefaults.standard.dictionary(forKey: Keys.pushNotificationsRegisteredDeployments) as? [String: String] ?? [:]
        dict[deploymentId] = pushProvider
        UserDefaults.standard.set(dict, forKey: Keys.pushNotificationsRegisteredDeployments)
    }
    
    class var savedPushDeploymentId: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.savedPushDeploymentId)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.savedPushDeploymentId)
        }
    }
    
    class var savedPushDomain: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.savedPushDomain)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.savedPushDomain)
        }
    }
}
