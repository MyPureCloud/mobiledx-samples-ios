// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit
import GenesysCloud
import GenesysCloudMessenger
import MessengerTransport
import FirebaseMessaging

class AccountDetailsViewController: UIViewController {
    @IBOutlet weak var deploymentIdTextField: UITextField!
    @IBOutlet weak var domainIdTextField: UITextField!
    @IBOutlet weak var sessionExpirationNoticeIntervalTextField: UITextField!
    @IBOutlet weak var customAttributesTextField: UITextField!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var loggingSwitch: UISwitch!
    @IBOutlet weak var implicitFlowSwitch: UISwitch!
    @IBOutlet weak var pushProviderToggle: UISegmentedControl!
    @IBOutlet weak var versionAndBuildLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!

    private var chatWrapperViewController: ChatWrapperViewController?

    private var authCode: String?
    private var codeVerifier: String?
    private var signInRedirectURI: String?
    private var idToken: String?
    private var nonce: String?

    private var shouldAuthorize = false

    private var pushProvider: GenesysCloud.PushProvider = .apns
    private var isRegisteredToPushNotifications = false

    private let accountRepository = AccountRepository()
    private let spinnerPresenter = SpinnerPresenter()
    private var pushService: PushNotificationService!
    private var pushObserver: PushNotificationObserver!
    private let toastPresenter = ToastPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        pushService = PushNotificationService(repository: accountRepository)
        pushObserver = PushNotificationObserver(
            onDeviceToken: handleDeviceToken(_:),
            onNotificationReceived: handleNotificationReceived(_:)
        )

        setupFields()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
           let transportVersionNumber = Bundle(for: MessengerTransportSDK.self).infoDictionary?["CFBundleShortVersionString"] as? String,
           let transportBuildNumber = Bundle(for: MessengerTransportSDK.self).infoDictionary?["CFBundleVersion"] as? String {
            versionAndBuildLabel.text = "Version: \(versionNumber), Build: \(buildNumber), Transport: \(transportVersionNumber).\(transportBuildNumber)"
        }

        loginButton.setTitle("LOGIN", for: .normal)

        setPushNotificationsViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinnerPresenter.attach(to: view)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        setPushNotificationsViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard checkInputFieldIsValid(deploymentIdTextField) &&
              checkInputFieldIsValid(domainIdTextField) else {
            return
        }

        setLoginButtonVisibility()
    }

    @objc func textFieldEditingDidChange(_ textField: UITextField) {
        if let deploymentId = deploymentIdTextField.text,
           let domainId = domainIdTextField.text {
            let fieldsAreEmpty = deploymentId.isEmpty && domainId.isEmpty
            startChatButton.isEnabled = !fieldsAreEmpty
            pushButton.isEnabled = !fieldsAreEmpty
        }
    }

    func setPushNotificationsViews() {
        guard let deploymentId = deploymentIdTextField.text else {
            Logger.error("Deployment ID not available")
            return
        }

        let pushProvider = accountRepository.pushProvider(for: deploymentId)
        let pushButtonTitle = pushProvider == nil ? "ENABLE PUSH" : "DISABLE PUSH"
        isRegisteredToPushNotifications = pushProvider != nil
        pushButton.setTitle(pushButtonTitle, for: .normal)

        if pushProvider != nil {
            pushProviderToggle.selectedSegmentIndex = pushProvider == "apns" ? 0 : 1
        }

        pushProviderToggle.isEnabled = pushProvider == nil
        self.pushProvider = pushProviderToggle.selectedSegmentIndex == 0 ? .apns : .fcm
    }

    @IBAction func pushButtonTapped(_ sender: Any) {
        Task { @MainActor in
            guard let deploymentId = deploymentIdTextField.text else {
                Logger.error("Deployment ID not available")
                return
            }

            if accountRepository.pushProvider(for: deploymentId) != nil {
                removeFromPushNotifications()
            } else {
                registerForPushNotifications()
            }
        }
    }

    @IBAction func pushProviderToggleChanged(_ sender: UISegmentedControl) {
        pushProvider = sender.selectedSegmentIndex == 0 ? .apns : .fcm
    }

    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        if let deploymentId = deploymentIdTextField.text,
           let domainId = domainIdTextField.text {
            startChatButton.isEnabled = !deploymentId.isEmpty && !domainId.isEmpty

            setLoginButtonVisibility()
        }
    }

    private func setLoginButtonVisibility() {
        if let account = createAccountForValidInputFields() {
            AuthenticationStatus.shouldAuthorize(account: account, completion: { [weak self] shouldAuthorize in
                guard let self else { return }
                self.shouldAuthorize = shouldAuthorize

                self.loginButton.isHidden = !shouldAuthorize
            })
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupFields() {
        domainIdTextField.delegate = self
        deploymentIdTextField.delegate = self
        sessionExpirationNoticeIntervalTextField.delegate = self
        customAttributesTextField.delegate = self
        domainIdTextField.returnKeyType = .done
        deploymentIdTextField.returnKeyType = .done
        sessionExpirationNoticeIntervalTextField.returnKeyType = .done
        customAttributesTextField.returnKeyType = .done
        domainIdTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        domainIdTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        sessionExpirationNoticeIntervalTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        sessionExpirationNoticeIntervalTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)

        deploymentIdTextField.text = accountRepository.deploymentId()
        domainIdTextField.text = accountRepository.domainId()
        sessionExpirationNoticeIntervalTextField.text = accountRepository.sessionExpirationNoticeInterval()
        customAttributesTextField.text = accountRepository.customAttributes()

        let logging = accountRepository.logging()
        loggingSwitch.setOn(logging, animated: true)
    }

    @IBAction func startChatButtonTapped(_ sender: UIButton) {
        if let account = createAccountForValidInputFields() {
            AuthenticationStatus.shouldAuthorize(account: account, completion: { [weak self] shouldAuthorize in
                guard let self else { return }
                self.shouldAuthorize = shouldAuthorize

                if let chatWrapperViewController,
                   let chatViewController = chatWrapperViewController.chatViewController {
                    present(chatWrapperViewController, animated: false) {
                        chatWrapperViewController.present(chatViewController, animated: true)
                    }
                    return
                }

                if let account = createAccountForValidInputFields() {
                    openMainController(with: account)
                } else {
                    Logger.error("Invalid account: required fields missing")
                }
            })
        }
    }

    @IBAction func chatAvailabilityButtonTapped(_ sender: UIButton) {
        if let account = createAccountForValidInputFields() {
            ChatAvailabilityChecker.checkAvailability(account) { isAvailable in
                Task { @MainActor in
                    await self.toastPresenter.present(
                        ToastView(
                            message: isAvailable ? "Chat is ENABLED" : "Chat is DISABLED",
                            backgroundColor: isAvailable ? UIColor.green : UIColor.red
                        )
                    )
                }
            }
        }
    }

    @IBAction func onLoginTapped(_ sender: Any) {
        startAuthentication()
    }

    private func startAuthentication(isImplicitFlowReauthorization: Bool = false) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: "AuthenticationViewController"
        ) as? AuthenticationViewController else { return }
        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.delegate = self
        controller.isImplicitFlow = implicitFlowSwitch.isOn
        controller.isImplicitFlowReauthorization = isImplicitFlowReauthorization

        UIApplication.getTopViewController()?.present(controller, animated: true)
    }

    private func checkInputFieldIsValid(_ inputField: UITextField) -> Bool {
        if inputField.text?.isEmpty == true {
            markInvalidTextField(inputField)
            return false
        }
        return true
    }

    private func checkSessionExpirationNoticeIntervalValidity(_ inputField: UITextField) -> Bool {
        guard let inputValue = inputField.text,
              let intValue = try? Int(inputValue, format: .number),
              intValue > 0 else {
            return false
        }

        return true
    }

    private func createAccountForValidInputFields() -> MessengerAccount? {
        guard checkInputFieldIsValid(deploymentIdTextField) &&
              checkInputFieldIsValid(domainIdTextField) else {
            showErrorAlert(message: "One or more required fields needed, please check & try again")
            return nil
        }

        let account: MessengerAccount

        if let sessionExpirationNoticeString = sessionExpirationNoticeIntervalTextField.text,
           let sessionExpirationNoticeInterval = try? Int(sessionExpirationNoticeString, format: .number) {
            account = MessengerAccount(
                deploymentId: deploymentIdTextField.text ?? "",
                domain: domainIdTextField.text ?? "",
                logging: loggingSwitch.isOn,
                sessionExpirationNoticeInterval: sessionExpirationNoticeInterval
            )
        } else {
            account = MessengerAccount(
                deploymentId: deploymentIdTextField.text ?? "",
                domain: domainIdTextField.text ?? "",
                logging: loggingSwitch.isOn
            )
        }

        let customAttributes = (customAttributesTextField.text ?? "").convertStringToDictionary()

        switch customAttributes {
        case .success(let result):
            account.customAttributes = result
        case .failure(let error):
            if error != .emptyData {
                showErrorAlert(message: "Custom Attributes JSON isn’t in the correct format")
                return nil
            }
        }

        if let authCode, let signInRedirectURI {
            account.setAuthenticationInfo(authCode: authCode, redirectUri: signInRedirectURI, codeVerifier: codeVerifier)
        }
        if let idToken, let nonce {
            account.setImplicitAuthenticationInfo(idToken: idToken, nonce: nonce)
        }

        updateUserDefaults()

        return account
    }

    private func showErrorAlert(message: String? = nil, error: GCError? = nil) {
        let alertMessage = message ?? error?.errorDescription ?? ""

        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self else { return }

            if let error {
                self.handleErrorPushDeploymentIdMismatch(error: error)
            }
        })
        okAlertAction.accessibilityIdentifier = "errorAlertOkButton"
        alert.addAction(okAlertAction)
        present(alert, animated: true)
    }

    private func handleErrorPushDeploymentIdMismatch(error: GCError) {
        guard error.errorType == .pushDeploymentIdMismatch else { return }

        guard let savedPushDeploymentId = accountRepository.pushDeploymentId(),
              let savedPushDomain = accountRepository.pushDomain() else {
            Logger.error("Saved push credentials not found for mismatch recovery")
            return
        }

        let sessionExpirationNoticeInterval: Int?
        let intervalString = accountRepository.sessionExpirationNoticeInterval()
        if !intervalString.isEmpty {
            sessionExpirationNoticeInterval = try? Int(intervalString, format: .number)
        } else {
            sessionExpirationNoticeInterval = nil
        }

        let account: MessengerAccount
        if let interval = sessionExpirationNoticeInterval, interval > 0 {
            account = MessengerAccount(
                deploymentId: savedPushDeploymentId,
                domain: savedPushDomain,
                logging: loggingSwitch.isOn,
                sessionExpirationNoticeInterval: interval
            )
        } else {
            account = MessengerAccount(
                deploymentId: savedPushDeploymentId,
                domain: savedPushDomain,
                logging: loggingSwitch.isOn
            )
        }

        removeFromPushNotifications(account: account)
    }

    private func markInvalidTextField(_ requiredTextField: UITextField) {
        requiredTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
    }

    private func updateUserDefaults() {
        accountRepository.save(deploymentId: deploymentIdTextField.text ?? "")
        accountRepository.save(domainId: domainIdTextField.text ?? "")
        accountRepository.save(sessionExpirationInterval: sessionExpirationNoticeIntervalTextField.text ?? "")
        accountRepository.save(logging: loggingSwitch.isOn)
        accountRepository.save(customAttributes: customAttributesTextField.text ?? "")
    }

    private func openMainController(with account: MessengerAccount) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(
            withIdentifier: "ChatWrapperViewController"
        ) as? ChatWrapperViewController else { return }
        controller.delegate = self
        controller.messengerAccount = account
        let hasOktaCode = accountRepository.hasOktaCode()
        controller.isAuthorized = shouldAuthorize || hasOktaCode
        controller.isRegisteredToPushNotifications = isRegisteredToPushNotifications
        controller.modalPresentationStyle = .fullScreen
        controller.modalPresentationCapturesStatusBarAppearance = true
        chatWrapperViewController = controller
        present(controller, animated: true)
    }
}

extension AccountDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Handle Authentication
extension AccountDetailsViewController: AuthenticationViewControllerDelegate, ChatWrapperViewControllerDelegate {
    func didReceive(chatElement: GenesysCloudCore.ChatElement) {
        Task { @MainActor in
            if let topViewController = UIApplication.getTopViewController(), topViewController is AccountDetailsViewController {
                let alertController = UIAlertController(
                    title: "New Message Arrived",
                    message: chatElement.getText(),
                    preferredStyle: .alert
                )

                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true)
            }
        }
    }

    func minimize() {
        dismiss(animated: true)
    }

    func dismiss() {
        chatWrapperViewController = nil
        dismiss(animated: true)
    }

    func didGetAuthInfo(authCode: String, redirectUri: String, codeVerifier: String?) {
        accountRepository.set(hasOktaCode: true)
        self.authCode = authCode
        self.signInRedirectURI = redirectUri
        self.codeVerifier = codeVerifier

        idToken = nil
        nonce = nil
    }

    func didGetImplicitAuthInfo(
        idToken: String,
        nonce: String,
        isReauthorization: Bool
    ) {
        accountRepository.set(hasOktaCode: true)
        self.idToken = idToken
        self.nonce = nonce

        authCode = nil
        signInRedirectURI = nil
        codeVerifier = nil

        if isReauthorization {
            chatWrapperViewController?.chatController.reauthorizeImplicitFlow(idToken: idToken, nonce: nonce)
        }
    }

    func error(message: String) {
        dismiss(animated: true, completion: {
            self.showErrorAlert(message: message)
        })
    }

    func authenticatedSessionError(message: String) {
        UIApplication.safelyDismissTopViewController(animated: false, completion: { [weak self] in
            guard let self else { return }

            let alert = UIAlertController(title: "Error occurred", message: message, preferredStyle: .alert)
            alert.view.accessibilityIdentifier = "alert_view"

            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.loginButton.isEnabled = true
            }))

            if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alert, animated: true)
            }
        })
    }

    func reauthorizationRequired() {
        startAuthentication(isImplicitFlowReauthorization: true)
    }
}

// MARK: Handle push notifications registration
extension AccountDetailsViewController {
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
            Task { @MainActor in
                if granted {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }

                    Logger.info("Registering for remote notifications")
                    self.pushProvider == .apns
                        ? appDelegate.registerForAPNsRemoteNotifications()
                        : appDelegate.registerForFCMRemoteNotifications()
                } else {
                    Logger.warning("Notifications disabled by user")
                    self.showNotificationSettingsAlert()
                }
            }
        }
    }

    private func removeFromPushNotifications(account: MessengerAccount? = nil) {
        let accountToUse: MessengerAccount

        if let providedAccount = account {
            accountToUse = providedAccount
        } else if let createdAccount = createAccountForValidInputFields() {
            accountToUse = createdAccount
        } else {
            Logger.error("Cannot create account from input fields")
            return
        }

        guard let deploymentId = deploymentIdTextField.text else {
            Logger.error("Deployment ID not available")
            return
        }

        spinnerPresenter.start()

        Task { @MainActor in
            defer { spinnerPresenter.stop() }

            do {
                try await pushService.removePushToken(account: accountToUse)
                await pushService.persistPushProvider(pushProvider: nil, for: deploymentId)
                await pushService.persistRegistration(deploymentId: nil, domain: nil)
                setPushNotificationsViews()
                await toastPresenter.present(ToastView(message: "Push Notifications are DISABLED"))
            } catch let error as GCError {
                let errorText = error.errorDescription ?? String(describing: error.errorType)
                showErrorAlert(message: "\(errorText), Deployment ID: \(deploymentId)")
            }
        }
    }

    private func showNotificationSettingsAlert() {
        let alertController = UIAlertController(
            title: "Notifications Disabled",
            message: "To receive updates, please enable notifications in settings.",
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        })

        self.present(alertController, animated: true)
    }

    func handleDeviceToken(_ notification: Notification) {
        let (account, deviceToken) = getAccountAndDeviceToken(notification)
        guard let account, let deviceToken else {
            Logger.error("Push provider selection failed")
            return
        }

        guard let deploymentId = deploymentIdTextField.text, let domain = domainIdTextField.text else {
            Logger.error("Deployment ID or domain not available")
            return
        }

        spinnerPresenter.start()
        Task { @MainActor in
            defer { spinnerPresenter.stop() }

            do {
                try await pushService.registerToken(deviceToken: deviceToken, pushProvider: pushProvider, account: account)
                await pushService.persistRegistration(deploymentId: deploymentId, domain: domain)
                await pushService.persistPushProvider(pushProvider: pushProvider, for: deploymentId)
                setPushNotificationsViews()
                await toastPresenter.present(
                    ToastView(
                        message: "Push Notifications are ENABLED"
                    )
                )
                Logger.info("Push provider registered: \(pushProvider)")
            } catch let error as GCError where error.errorDescription == "Device already registered." {
                await pushService.persistRegistration(deploymentId: deploymentId, domain: domain)
                await pushService.persistPushProvider(pushProvider: pushProvider, for: deploymentId)
                setPushNotificationsViews()
                showErrorAlert(error: error)
            } catch let error as GCError {
                showErrorAlert(error: error)
            }
        }
    }

    private func getAccountAndDeviceToken(_ notification: Notification) -> (Account?, String?) {
        guard let userInfo = notification.userInfo else {
            showErrorAlert(message: "Error: empty userInfo")
            return (nil, nil)
        }

        guard let account = self.createAccountForValidInputFields() else {
            showErrorAlert(message: "Error: can't create account")
            return (nil, nil)
        }

        var deviceToken: String?

        if pushProvider == .apns {
            guard let apnsToken = userInfo["apnsToken"] as? String else {
                Logger.error("APNS device token not found")
                return (nil, nil)
            }
            deviceToken = apnsToken
        } else if pushProvider == .fcm {
            guard let fcmToken = userInfo["fcmToken"] as? String else {
                Logger.error("FCM device token not found")
                return (nil, nil)
            }

            deviceToken = fcmToken
        }

        return (account, deviceToken)
    }
}

// MARK: Handle receiving notifications
extension AccountDetailsViewController {
    func handleNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            Logger.error("Notification userInfo empty")
            return
        }

        guard UIApplication.shared.applicationState == .active else {
            Logger.info("App not in foreground")
            return
        }

        guard let senderID = userInfo["deeplink"] as? String else {
            Logger.warning("Sender ID not found in notification")
            return
        }

        if senderID == "genesys-messaging" {
            showNotificationReceivedAlert(userInfo: userInfo)
        }
    }

    private func showNotificationReceivedAlert(userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let title = alert["title"] as? String,
           let body = alert["body"] as? String {
            let alertController = UIAlertController(
                title: title,
                message: body,
                preferredStyle: .alert
            )

            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alertController, animated: true)
            }
        } else {
            Logger.error("Failed to retrieve notification userInfo")
        }
    }

    func didLogout() {
        authCode = nil
        signInRedirectURI = nil
        codeVerifier = nil
        nonce = nil
        idToken = nil
        chatWrapperViewController = nil
        accountRepository.set(hasOktaCode: false)
    }

    func didUnregisterPushNotifications() {
        guard let deploymentId = deploymentIdTextField.text else {
            Logger.error("Deployment ID not available for push cleanup")
            return
        }

        accountRepository.set(pushProvider: nil, for: deploymentId)
        accountRepository.set(pushDeploymentId: nil)
        accountRepository.set(pushDomain: nil)
        isRegisteredToPushNotifications = false
        setPushNotificationsViews()
    }
}
