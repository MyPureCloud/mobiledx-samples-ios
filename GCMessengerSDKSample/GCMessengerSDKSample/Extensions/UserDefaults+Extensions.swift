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

}
