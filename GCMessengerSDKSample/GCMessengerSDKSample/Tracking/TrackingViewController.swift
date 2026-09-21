// ===================================================================================================
// Copyright © 2026 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloudMessenger

/// Actions that can be performed on the active tracker. Each maps to a button on the screen.
private enum TrackingAction {
    case applySetters
    case screenViewed
    case searchPerformed
    case customEvent
    case setTraits
    case getSessionId
    case clear
    case startChat
}

/// Configuration for one free-text input row: its label, backing text view, template contents, and
/// the accessibility identifiers for its template/info buttons and info dialog.
private struct InputSection {
    let title: String
    let textView: UITextView
    let template: String
    let templateButtonIdentifier: String
    let infoButtonIdentifier: String
    let infoDialogIdentifier: String
    let infoMessage: String
}

/// Demonstrates and drives Mobile Tracking journey events after the tracker has been initiated on a
/// `MessengerAccount` (see `SampleAccountHolder`).
///
/// The UI is intentionally minimal so it can be driven from an automation harness (e.g. Appium): two
/// free-text inputs (`TrackingInputParser`) and one button per action, all reachable via
/// `accessibilityIdentifier`.
final class TrackingViewController: UIViewController {
    // MARK: - Properties

    /// Invoked when the user taps "Start Chat" so the host can start a Messaging session on the same
    /// account that has tracking initiated (carrying the journey context).
    var onStartChat: ((MessengerAccount) -> Void)?

    private var account: MessengerAccount? { SampleAccountHolder.shared.account }
    private var tracking: MessengerTracking? { account?.tracking }

    private let settersTextView = TrackingViewController.makeTextView(identifier: "tracking_setters_input")
    private let traitsTextView = TrackingViewController.makeTextView(identifier: "tracking_traits_input")
    private let statusLabel = UILabel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tracking"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(makeInputSection(InputSection(
            title: "Setters / event input",
            textView: settersTextView,
            template: TrackingInputParser.settersTemplate,
            templateButtonIdentifier: "tracking_setters_template_button",
            infoButtonIdentifier: "tracking_setters_info_button",
            infoDialogIdentifier: "tracking_setters_info_dialog",
            infoMessage: Constants.settersInfoMessage
        )))
        contentStack.addArrangedSubview(makeInputSection(InputSection(
            title: "Traits input",
            textView: traitsTextView,
            template: TrackingInputParser.traitsTemplate,
            templateButtonIdentifier: "tracking_traits_template_button",
            infoButtonIdentifier: "tracking_traits_info_button",
            infoDialogIdentifier: "tracking_traits_info_dialog",
            infoMessage: Constants.traitsInfoMessage
        )))

        contentStack.addArrangedSubview(makeButtonRow([
            makeButton(title: "Apply Setters", identifier: "tracking_apply_setters_button") { [weak self] in self?.run(.applySetters) },
            makeButton(title: "Set Traits", identifier: "tracking_set_traits_button") { [weak self] in self?.run(.setTraits) }
        ]))
        contentStack.addArrangedSubview(makeButtonRow([
            makeButton(title: "Screen Viewed", identifier: "tracking_screen_viewed_button") { [weak self] in self?.run(.screenViewed) },
            makeButton(title: "Search Performed", identifier: "tracking_search_performed_button") { [weak self] in
                self?.run(.searchPerformed)
            }
        ]))
        contentStack.addArrangedSubview(makeButtonRow([
            makeButton(title: "Custom Event", identifier: "tracking_custom_event_button") { [weak self] in self?.run(.customEvent) },
            makeButton(title: "Get Session Id", identifier: "tracking_get_session_id_button") { [weak self] in self?.run(.getSessionId) }
        ]))
        contentStack.addArrangedSubview(makeButtonRow([
            makeButton(title: "Start Chat", identifier: "tracking_start_chat_button") { [weak self] in self?.run(.startChat) },
            makeButton(title: "Clear", identifier: "tracking_clear_button") { [weak self] in self?.run(.clear) }
        ]))

        statusLabel.numberOfLines = 0
        statusLabel.font = .preferredFont(forTextStyle: .footnote)
        statusLabel.accessibilityIdentifier = "tracking_status"
        contentStack.addArrangedSubview(statusLabel)

        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: contentGuide.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor, constant: -12),
            contentStack.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -12),
            contentStack.widthAnchor.constraint(equalTo: frameGuide.widthAnchor, constant: -24)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func makeInputSection(_ section: InputSection) -> UIView {
        let label = UILabel()
        label.text = section.title
        label.font = .preferredFont(forTextStyle: .subheadline)

        let templateButton = UIButton(type: .system)
        templateButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        templateButton.accessibilityIdentifier = section.templateButtonIdentifier
        templateButton.addAction(UIAction { _ in section.textView.text = section.template }, for: .touchUpInside)

        let infoButton = UIButton(type: .infoLight)
        infoButton.accessibilityIdentifier = section.infoButtonIdentifier
        infoButton.addAction(UIAction { [weak self] _ in
            self?.presentInfo(message: section.infoMessage, identifier: section.infoDialogIdentifier)
        }, for: .touchUpInside)

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let headerStack = UIStackView(arrangedSubviews: [label, spacer, templateButton, infoButton])
        headerStack.axis = .horizontal
        headerStack.spacing = 4
        headerStack.alignment = .center

        let stack = UIStackView(arrangedSubviews: [headerStack, section.textView])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }

    private func presentInfo(message: String, identifier: String) {
        let alert = UIAlertController(title: "Supported keys", message: message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = identifier
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func makeButtonRow(_ buttons: [UIButton]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }

    private func makeButton(title: String, identifier: String, action: @escaping () -> Void) -> UIButton {
        var config = UIButton.Configuration.borderedProminent()
        config.title = title
        config.titleLineBreakMode = .byTruncatingTail
        let button = UIButton(configuration: config, primaryAction: UIAction { _ in action() })
        button.accessibilityIdentifier = identifier
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        return button
    }

    private static func makeTextView(identifier: String) -> UITextView {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 6
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.accessibilityIdentifier = identifier
        textView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        return textView
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions

    private func run(_ action: TrackingAction) {
        statusLabel.text = perform(action)
    }

    private func perform(_ action: TrackingAction) -> String {
        switch action {
        case .clear:
            account?.resetTrackingIdentity()
            return "Tracking identity cleared"
        case .startChat:
            guard let account else { return "Tracking is not available" }
            onStartChat?(account)
            return "Starting chat…"
        default:
            break
        }

        guard let tracking else { return "Tracking is not available" }

        let settersText = settersTextView.text ?? ""
        let traitsText = traitsTextView.text ?? ""
        let pairs = TrackingInputParser.parsePairs(settersText)
        let screenName = TrackingInputParser.screenName(pairs) ?? Constants.defaultScreenName
        let attributes = TrackingInputParser.attributes(pairs)
        let eventTraits = TrackingInputParser.traits(traitsText)

        switch action {
        case .applySetters:
            TrackingInputParser.applyConfig(tracking, pairs: pairs)
            return "Setters applied"
        case .screenViewed:
            tracking.screenViewed(
                screenName: screenName,
                attributes: attributes,
                searchQuery: TrackingInputParser.searchQuery(pairs),
                traits: eventTraits
            )
            return "Event sent: \(screenName)"
        case .searchPerformed:
            tracking.searchPerformed(screenName: screenName, attributes: attributes, traits: eventTraits)
            return "Event sent: \(screenName)"
        case .customEvent:
            let eventName = TrackingInputParser.eventName(pairs) ?? Constants.defaultCustomEventName
            tracking.customEvent(eventName: eventName, screenName: screenName, attributes: attributes, traits: eventTraits)
            return "Event sent: \(eventName)"
        case .setTraits:
            guard let eventTraits else { return "No traits to set" }
            tracking.setTraits(eventTraits)
            return "Traits set"
        case .getSessionId:
            guard let sessionId = tracking.getSessionId(), !sessionId.isEmpty else {
                return "No active tracking session"
            }
            return "Session id: \(sessionId)"
        case .clear, .startChat:
            return "" // handled above
        }
    }

    private enum Constants {
        static let defaultScreenName = "HomeScreen"
        static let defaultCustomEventName = "custom_event"
        static let settersInfoMessage = """
        One key=value per line (or ; separated).

        screenName, searchQuery, eventName, externalId, attr.<name> (event attributes; \
        type-inferred as Bool, Int, Double, else String).

        Metadata setters (applied via Apply Setters): appName, appNamespace, appVersion, \
        appBuildNumber, deviceCategory (mobile/desktop/tablet/other), deviceType, osFamily, \
        osVersion, isMobile, screenHeight, screenWidth, screenDensity, fingerprint, \
        manufacturer, carrier, bluetoothEnabled, cellularEnabled, wifiEnabled.
        """
        static let traitsInfoMessage = """
        One key=value per line (or ; separated).

        email, cellPhone, homePhone, otherPhone, workPhone, salutation, jobTitle, \
        givenName, middleName, familyName.
        """
    }
}
