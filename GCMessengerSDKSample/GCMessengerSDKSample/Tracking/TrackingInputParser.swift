// ===================================================================================================
// Copyright © 2026 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import GenesysCloudMessenger

/// Parses the two free-text inputs of the tracking screen into Mobile Tracking SDK calls.
///
/// The whole screen is driven by text so it can be injected from an automation harness (e.g. Appium).
/// Format: one `key=value` per line (`;` is also accepted as a separator). Unknown keys are ignored,
/// empty inputs produce minimal/`nil` results so "required-fields-only" cases are easy to express.
///
/// Setter keys: `screenName`, `searchQuery`, `eventName`, `externalId`, the metadata setters
/// (`appName`, `appNamespace`, `appVersion`, `appBuildNumber`, `deviceCategory`, `deviceType`,
/// `osFamily`, `osVersion`, `isMobile`, `screenHeight`, `screenWidth`, `screenDensity`, `fingerprint`,
/// `manufacturer`, `carrier`, `bluetoothEnabled`, `cellularEnabled`, `wifiEnabled`) and `attr.<name>`
/// pairs that become the event attributes map (values are type-inferred: `Bool` → `Int` → `Double` →
/// else `String`).
///
/// Trait keys mirror `TrackingTraits`: `email`, `cellPhone`, `homePhone`, `otherPhone`, `workPhone`,
/// `salutation`, `jobTitle`, `givenName`, `middleName`, `familyName`.
enum TrackingInputParser {
    private static let attrPrefix = "attr."

    /// Inserted by the setters template button: every supported key with no value, so an untouched
    /// line is a no-op. Includes three example `attr.<name>` placeholders.
    static let settersTemplate = """
    screenName=
    searchQuery=
    eventName=
    externalId=
    appName=
    appNamespace=
    appVersion=
    appBuildNumber=
    deviceCategory=
    deviceType=
    osFamily=
    osVersion=
    isMobile=
    screenHeight=
    screenWidth=
    screenDensity=
    fingerprint=
    manufacturer=
    carrier=
    bluetoothEnabled=
    cellularEnabled=
    wifiEnabled=
    attr.attr1=
    attr.attr2=
    attr.attr3=
    """

    /// Inserted by the traits template button: every supported key with no value, so an untouched
    /// line is a no-op.
    static let traitsTemplate = """
    email=
    cellPhone=
    homePhone=
    otherPhone=
    workPhone=
    salutation=
    jobTitle=
    givenName=
    middleName=
    familyName=
    """

    static func parsePairs(_ input: String) -> [String: String] {
        var pairs: [String: String] = [:]
        let lines = input.components(separatedBy: CharacterSet(charactersIn: "\n;"))
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard let separatorIndex = trimmed.firstIndex(of: "=") else { continue }
            let key = String(trimmed[..<separatorIndex]).trimmingCharacters(in: .whitespaces)
            let value = String(trimmed[trimmed.index(after: separatorIndex)...]).trimmingCharacters(in: .whitespaces)
            guard !key.isEmpty else { continue }
            pairs[key] = value
        }
        return pairs
    }

    static func screenName(_ pairs: [String: String]) -> String? { pairs["screenName"]?.nonEmpty }

    static func searchQuery(_ pairs: [String: String]) -> String? { pairs["searchQuery"]?.nonEmpty }

    static func eventName(_ pairs: [String: String]) -> String? { pairs["eventName"]?.nonEmpty }

    static func attributes(_ pairs: [String: String]) -> [String: Any]? {
        var attributes: [String: Any] = [:]
        for (key, value) in pairs where key.hasPrefix(attrPrefix) && key.count > attrPrefix.count && !value.isEmpty {
            attributes[String(key.dropFirst(attrPrefix.count))] = inferAttributeValue(value)
        }
        return attributes.isEmpty ? nil : attributes
    }

    static func traits(_ input: String) -> TrackingTraits? {
        let pairs = parsePairs(input)
        let email = pairs["email"]?.nonEmpty
        let cellPhone = pairs["cellPhone"]?.nonEmpty
        let homePhone = pairs["homePhone"]?.nonEmpty
        let otherPhone = pairs["otherPhone"]?.nonEmpty
        let workPhone = pairs["workPhone"]?.nonEmpty
        let salutation = pairs["salutation"]?.nonEmpty
        let jobTitle = pairs["jobTitle"]?.nonEmpty
        let givenName = pairs["givenName"]?.nonEmpty
        let middleName = pairs["middleName"]?.nonEmpty
        let familyName = pairs["familyName"]?.nonEmpty

        guard email != nil || cellPhone != nil || homePhone != nil || otherPhone != nil || workPhone != nil ||
              salutation != nil || jobTitle != nil || givenName != nil || middleName != nil || familyName != nil else {
            return nil
        }

        return TrackingTraits(
            email: email,
            cellPhone: cellPhone,
            homePhone: homePhone,
            otherPhone: otherPhone,
            workPhone: workPhone,
            salutation: salutation,
            jobTitle: jobTitle,
            givenName: givenName,
            middleName: middleName,
            familyName: familyName
        )
    }

    /// Applies any session-metadata setters and `externalId` found in `pairs` to `tracking`. Values
    /// that fail type conversion (e.g. a non-integer `screenHeight`) are skipped.
    static func applyConfig(_ tracking: MessengerTracking, pairs: [String: String]) {
        pairs["externalId"]?.nonEmpty.map { tracking.setExternalId($0) }
        pairs["appName"]?.nonEmpty.map { tracking.setAppName($0) }
        pairs["appNamespace"]?.nonEmpty.map { tracking.setAppNamespace($0) }
        pairs["appVersion"]?.nonEmpty.map { tracking.setAppVersion($0) }
        pairs["appBuildNumber"]?.nonEmpty.map { tracking.setAppBuildNumber($0) }
        pairs["deviceCategory"].flatMap(deviceCategory(from:)).map { tracking.setDeviceCategory($0) }
        pairs["deviceType"]?.nonEmpty.map { tracking.setDeviceType($0) }
        pairs["osFamily"]?.nonEmpty.map { tracking.setOsFamily($0) }
        pairs["osVersion"]?.nonEmpty.map { tracking.setOsVersion($0) }
        pairs["isMobile"].flatMap(strictBool(from:)).map { tracking.setIsMobile($0) }
        pairs["screenHeight"].flatMap { Int($0) }.map { tracking.setScreenHeight($0) }
        pairs["screenWidth"].flatMap { Int($0) }.map { tracking.setScreenWidth($0) }
        pairs["screenDensity"].flatMap { Int($0) }.map { tracking.setScreenDensity($0) }
        pairs["fingerprint"]?.nonEmpty.map { tracking.setFingerprint($0) }
        pairs["manufacturer"]?.nonEmpty.map { tracking.setManufacturer($0) }
        pairs["carrier"]?.nonEmpty.map { tracking.setCarrier($0) }
        pairs["bluetoothEnabled"].flatMap(strictBool(from:)).map { tracking.setBluetoothEnabled($0) }
        pairs["cellularEnabled"].flatMap(strictBool(from:)).map { tracking.setCellularEnabled($0) }
        pairs["wifiEnabled"].flatMap(strictBool(from:)).map { tracking.setWifiEnabled($0) }
    }

    private static func deviceCategory(from value: String) -> DeviceCategory? {
        switch value.lowercased() {
        case "mobile": return .mobile
        case "desktop": return .desktop
        case "tablet": return .tablet
        case "other": return .other
        default: return nil
        }
    }

    private static func strictBool(from value: String) -> Bool? {
        switch value.lowercased() {
        case "true": return true
        case "false": return false
        default: return nil
        }
    }

    /// Infers `Bool` → `Int` → `Double`, otherwise keeps the raw `String`. `Bool` only matches an
    /// exact `"true"`/`"false"` (case-insensitive) so numeric-looking strings like `"1"` fall through
    /// to `Int`.
    private static func inferAttributeValue(_ raw: String) -> Any {
        if let bool = strictBool(from: raw) { return bool }
        if let intValue = Int(raw) { return intValue }
        if let doubleValue = Double(raw) { return doubleValue }
        return raw
    }
}

private extension String {
    var nonEmpty: String? { isEmpty ? nil : self }
}
