// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  /// Cancel
  internal static let cancel = Localization.tr("Localization", "cancel", fallback: "Cancel")
  /// Error: can't create account
  internal static let cannotCreateAccountError = Localization.tr("Localization", "cannot_create_account_error", fallback: "Error: can't create account")
  /// Clear Conversation
  internal static let clearConversation = Localization.tr("Localization", "clear_conversation", fallback: "Clear Conversation")
  /// Would you like to clear and leave your conversation? Message history will be lost.
  internal static let clearConversationMessage = Localization.tr("Localization", "clear_conversation_message", fallback: "Would you like to clear and leave your conversation? Message history will be lost.")
  /// Conversation was cleared.
  internal static let conversationCleared = Localization.tr("Localization", "conversation_cleared", fallback: "Conversation was cleared.")
  /// DISABLE PUSH
  internal static let disablePush = Localization.tr("Localization", "disable_push", fallback: "DISABLE PUSH")
  /// Chat was disconnected
  internal static let disconnected = Localization.tr("Localization", "disconnected", fallback: "Chat was disconnected")
  /// We were not able to restore chat connection.
  /// Make sure your device is connected.
  internal static let disconnectedMessage = Localization.tr("Localization", "disconnected_message", fallback: "We were not able to restore chat connection.\nMake sure your device is connected.")
  /// Error: empty userInfo
  internal static let emptyUserInfoError = Localization.tr("Localization", "empty_user_info_error", fallback: "Error: empty userInfo")
  /// To receive updates, please enable notifications in settings.
  internal static let enableNotifications = Localization.tr("Localization", "enable_notifications", fallback: "To receive updates, please enable notifications in settings.")
  /// ENABLE PUSH
  internal static let enablePush = Localization.tr("Localization", "enable_push", fallback: "ENABLE PUSH")
  /// End Chat
  internal static let endChat = Localization.tr("Localization", "end_chat", fallback: "End Chat")
  /// Error occurred
  internal static let errorOccured = Localization.tr("Localization", "error_occured", fallback: "Error occurred")
  /// Custom Attributes JSON isn’t in the correct format
  internal static let incorrectJSONFormat = Localization.tr("Localization", "incorrect_jSON_format", fallback: "Custom Attributes JSON isn’t in the correct format")
  /// LOGIN
  internal static let login = Localization.tr("Localization", "login", fallback: "LOGIN")
  /// Notifications Disabled
  internal static let notificationsDisabled = Localization.tr("Localization", "notifications_disabled", fallback: "Notifications Disabled")
  /// OK
  internal static let ok = Localization.tr("Localization", "ok", fallback: "OK")
  /// Reconnect
  internal static let reconnect = Localization.tr("Localization", "reconnect", fallback: "Reconnect")
  /// One or more required fields needed, please check & try again
  internal static let requiredFieldError = Localization.tr("Localization", "required_field_error", fallback: "One or more required fields needed, please check & try again")
  /// Messenger was restricted and can't be processed.
  internal static let restrictedError = Localization.tr("Localization", "restricted_error", fallback: "Messenger was restricted and can't be processed.")
  /// Settings
  internal static let settings = Localization.tr("Localization", "settings", fallback: "Settings")
  /// Start chat
  internal static let startChat = Localization.tr("Localization", "start_chat", fallback: "Start chat")
  /// Yes I'm Sure
  internal static let sure = Localization.tr("Localization", "sure", fallback: "Yes I'm Sure")
  /// You have been logged out because the session limit was exceeded.
  internal static let timedOut = Localization.tr("Localization", "timed_out", fallback: "You have been logged out because the session limit was exceeded.")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
