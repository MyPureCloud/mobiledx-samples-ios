// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Combine
import GenesysCloud
import MessengerTransport
import FirebaseMessaging

class AccountDetailsViewController: UIViewController {
    @IBOutlet weak var deploymentIdTextField: UITextField!
    @IBOutlet weak var domainIdTextField: UITextField!
    @IBOutlet weak var customAttributesTextField: UITextField!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var loggingSwitch: UISwitch!
    @IBOutlet weak var pushProviderToggle: UISegmentedControl!
    @IBOutlet weak var versionAndBuildLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!

    let wrapperActivityView = UIActivityIndicatorView(style: .large)

    private var chatWrapperViewController: ChatWrapperViewController?

    private var authCode: String?
    private var codeVerifier: String?
    private var signInRedirectURI: String?

    private var pushProvider: GenesysCloud.PushProvider = .apns
    private let pushManager = PushActionManager()
    private var cancellables = Set<AnyCancellable>()

    private var isRegisteredToPushNotifications = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
           let transportVersionNumber = Bundle(for: MessengerTransportSDK.self).infoDictionary?["CFBundleShortVersionString"] as? String,
           let transportBuildNumber = Bundle(for: MessengerTransportSDK.self).infoDictionary?["CFBundleVersion"] as? String {
            versionAndBuildLabel.text = "Version: \(versionNumber), Build: \(buildNumber), Transport: \(transportVersionNumber).\(transportBuildNumber)"
        }

        loginButton.setTitle(Localization.login, for: .normal)

        setPushNotificationsViews()
        registerForNotificationsObservers()
        subscribe()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSpinner(activityView: wrapperActivityView, view: view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard checkInputFieldIsValid(deploymentIdTextField) || checkInputFieldIsValid(domainIdTextField) else {
            return
        }

        setLoginButtonVisibility()
    }

    private func subscribe() {
        pushManager.pushNotificationViewSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.setPushNotificationsViews()
            }
            .store(in: &cancellables)

        pushManager.snackbarViewSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.pushManager.showPushSnackbar()
            }
            .store(in: &cancellables)

        pushManager.toastSubject
            .receive(on: DispatchQueue.main)
            .sink { message in
                ToastManager.shared.showToast(message: message)
            }
            .store(in: &cancellables)

        pushManager.errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] failure in
                switch failure {
                case .pushDisabled:
                    self?.showNotificationSettingsAlert()
                case .error(let error):
                    self?.showErrorAlert(error: error)
                }
            }
            .store(in: &cancellables)
    }

    func setPushNotificationsViews() {
        guard let deploymentId = deploymentIdTextField.text else {
            NSLog("Can't get deployment ID")
            return
        }

        let pushProvider = UserDefaults.getPushProviderFor(deploymentId: deploymentId)
        let pushButtonTitle = pushProvider == nil ? Localization.enablePush : Localization.disablePush
        isRegisteredToPushNotifications = pushProvider != nil
        pushButton.setTitle(pushButtonTitle, for: .normal)

        if pushProvider != nil {
            pushProviderToggle.selectedSegmentIndex = pushProvider == "apns" ? 0 : 1
        }

        pushProviderToggle.isEnabled = pushProvider == nil
        self.pushProvider = pushProviderToggle.selectedSegmentIndex == 0 ? .apns : .fcm
    }

    func setSpinner(activityView: UIActivityIndicatorView, view: UIView?) {
        activityView.frame = view?.frame ?? .zero
        activityView.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        activityView.center = view?.center ?? .zero

        activityView.hidesWhenStopped = true

        view?.addSubview(activityView)
    }

    func startSpinner(activityView: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityView.startAnimating()
        }
    }

    func stopSpinner(activityView: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityView.stopAnimating()
        }
    }

    private func setLoginButtonVisibility() {
        if let account = createAccountForValidInputFields() {
            AuthenticationStatus.shouldAuthorize(account: account) { [weak self] shouldAuthorize in
                guard let self else { return }

                loginButton.isHidden = !shouldAuthorize
            }
        }
    }

    private func updateUserDefaults() {
        UserDefaults.deploymentId = deploymentIdTextField.text ?? ""
        UserDefaults.domainId = domainIdTextField.text ?? ""
        UserDefaults.logging = loggingSwitch.isOn
        UserDefaults.customAttributes = customAttributesTextField.text ?? ""
    }

    private func openMainController(with account: MessengerAccount) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ChatWrapperViewController") as? ChatWrapperViewController else { return }
        controller.delegate = self
        controller.messengerAccount = account
        controller.isAuthorized = loginButton.isHidden || authCode != nil
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

// MARK: @IBAction functions
extension AccountDetailsViewController {
    @IBAction func pushButtonTapped(_ sender: Any) {
        guard let deploymentId = deploymentIdTextField.text else {
            NSLog("Can't get deployment ID")
            return
        }

        if UserDefaults.getPushProviderFor(deploymentId: deploymentId) != nil {
            guard let accountToUse = createAccountForValidInputFields() else {
                NSLog("Error: can't create account from input fields")
                return
            }

            startSpinner(activityView: wrapperActivityView)
            pushManager.removeFromPushNotifications(account: accountToUse, deploymentId: deploymentId)
            stopSpinner(activityView: wrapperActivityView)
        } else {
            Task {
                await pushManager.registerForPushNotifications(pushProvider: pushProvider)
            }
        }
    }

    @IBAction func pushProviderToggleChanged(_ sender: UISegmentedControl) {
        pushProvider = sender.selectedSegmentIndex == 0 ? .apns : .fcm
    }

    @IBAction func startChatButtonTapped(_ sender: UIButton) {
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
            NSLog("Invalid account, one or more required fields needed, please check & try again")
        }
    }

    @IBAction func chatAvailabilityButtonTapped(_ sender: UIButton) {
        if let account = createAccountForValidInputFields() {
            ChatAvailabilityChecker.checkAvailability(account) { result in
                if let result {
                    ToastManager.shared.showToast(message: "Chat availability status returned \(result.isAvailable)", backgroundColor: result.isAvailable ? UIColor.green : UIColor.red)
                }
            }
        }
    }

    @IBAction func onLoginTapped(_ sender: Any) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "AuthenticationViewController") as? AuthenticationViewController else { return }

        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.delegate = self
        present(controller, animated: true)
    }
}

// MARK: TextField configuration
extension AccountDetailsViewController {
    @objc func textFieldEditingDidChange(_ textField: UITextField) {
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            let domainAndDeploymentIdsAreEmpty = deploymentId.isEmpty && domainId.isEmpty
            startChatButton.isEnabled = !domainAndDeploymentIdsAreEmpty
            pushButton.isEnabled = !domainAndDeploymentIdsAreEmpty
        }
    }

    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            startChatButton.isEnabled = !deploymentId.isEmpty && !domainId.isEmpty

            setLoginButtonVisibility()
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupFields() {
        domainIdTextField.delegate = self
        deploymentIdTextField.delegate = self
        customAttributesTextField.delegate = self

        domainIdTextField.returnKeyType = .done
        deploymentIdTextField.returnKeyType = .done
        customAttributesTextField.returnKeyType = .done
        domainIdTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        domainIdTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)

        deploymentIdTextField.text = UserDefaults.deploymentId
        domainIdTextField.text = UserDefaults.domainId
        customAttributesTextField.text = UserDefaults.customAttributes

        loggingSwitch.setOn(UserDefaults.logging, animated: true)
    }

    private func checkInputFieldIsValid(_ inputField: UITextField) -> Bool {
        if inputField.text?.isEmpty == true {
            markInvalidTextField(inputField)
            return false
        }
        return true
    }

    private func markInvalidTextField(_ requiredTextField: UITextField) {
        requiredTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
    }
}

// MARK: Handle Authentication
extension AccountDetailsViewController: AuthenticationViewControllerDelegate, ChatWrapperViewControllerDelegate {
    func didReceive(chatElement: GenesysCloudCore.ChatElement) {
        Task { @MainActor [weak self] in
            guard let self else { return }

            let alertController = UIAlertController(
                title: "New Message Arrived",
                message: chatElement.getText(),
                preferredStyle: .alert
            )

            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }

    func minimize() {
        dismiss(animated: true)
    }

    func dismiss() {
        chatWrapperViewController = nil
        dismiss(animated: true)
    }

    func authenticationSucceeded(authCode: String, redirectUri: String, codeVerifier: String?) {
        self.authCode = authCode
        self.signInRedirectURI = redirectUri
        self.codeVerifier = codeVerifier

        dismiss(animated: true, completion: nil)
    }

    func error(message: String) {
        dismiss(animated: true) {
            self.showErrorAlert(message: message)
        }
    }

    func authenticatedSessionError(message: String) {
        UIApplication.safelyDismissTopViewController(animated: true, completion: { [weak self] in
            guard let self else { return }

            let alert = UIAlertController(title: Localization.errorOccured, message: message, preferredStyle: .alert)
            alert.view.accessibilityIdentifier = "alert_view"

            alert.addAction(UIAlertAction(title: Localization.ok, style: .cancel) { _ in
                self.loginButton.isEnabled = true
            })

            if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alert, animated: true)
            }
        })
    }

    func didLogout() {
        authCode = nil
        signInRedirectURI = nil
        codeVerifier = nil
    }
}

// MARK: Push notifications registration
extension AccountDetailsViewController {
    private func createAccountForValidInputFields() -> MessengerAccount? {
        guard checkInputFieldIsValid(deploymentIdTextField) || checkInputFieldIsValid(domainIdTextField) else {
            showErrorAlert(message: Localization.requiredFieldError)
            return nil
        }

        let account = MessengerAccount(
            deploymentId: deploymentIdTextField.text ?? "",
            domain: domainIdTextField.text ?? "",
            logging: loggingSwitch.isOn
        )

        do {
            let customAttributes = try (customAttributesTextField.text ?? "").convertStringToDictionary()
            account.customAttributes = customAttributes
        } catch {
            if error as? ConvertError != ConvertError.emptyData {
                showErrorAlert(message: Localization.incorrectJSONFormat)
                return nil
            }
        }

        if let authCode, let signInRedirectURI {
            account.setAuthenticationInfo(authCode: authCode, redirectUri: signInRedirectURI, codeVerifier: codeVerifier)
        }

        updateUserDefaults()

        return account
    }

    private func getAccountAndDeviceToken(_ notification: Notification) -> (Account?, String?) {
        guard let userInfo = notification.userInfo else {
            showErrorAlert(message: Localization.emptyUserInfoError)
            return (nil, nil)
        }

        guard let account = self.createAccountForValidInputFields() else {
            showErrorAlert(message: Localization.cannotCreateAccountError)
            return (nil, nil)
        }

        var deviceToken: String?

        if pushProvider == .apns {
            guard let apnsToken = userInfo["apnsToken"] as? String else {
                NSLog("Error: no device token for .apns push provider")
                return (nil, nil)
            }
            deviceToken = apnsToken
        } else if pushProvider == .fcm {
            guard let fcmToken = userInfo["fcmToken"] as? String else {
                NSLog("Error: no device token for .fcm push provider")
                return (nil, nil)
            }

            deviceToken = fcmToken
        }

        return (account, deviceToken)
    }
}

// MARK: Handle receiving notifications
extension AccountDetailsViewController {
    private func registerForNotificationsObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDeviceToken(_:)),
            name: Notification.Name.deviceTokenReceived,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotificationReceived(_:)),
            name: Notification.Name.notificationReceived,
            object: nil
        )
    }

    @objc private func handleDeviceToken(_ notification: Notification) {
        startSpinner(activityView: wrapperActivityView)

        let (account, deviceToken) = getAccountAndDeviceToken(notification)

        pushManager.handleDeviceToken(
            pushProvider: pushProvider,
            account: account,
            deviceToken: deviceToken,
            deploymentId: deploymentIdTextField.text,
            domain: domainIdTextField.text
        )
        stopSpinner(activityView: wrapperActivityView)
    }

    @objc func handleNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            NSLog("Error: empty userInfo")
            return
        }

        guard UIApplication.shared.applicationState == .active else {
            NSLog("App is not in foreground")
            return
        }

        guard let senderID = userInfo["deeplink"] as? String else {
            NSLog("Sender ID not found")
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
            NSLog("Error retrieving UserInfo")
        }
    }
}

// MARK: Error handling
extension AccountDetailsViewController {
    private func showErrorAlert(message: String? = nil, error: GCError? = nil) {
        let alertMessage = message ?? error?.errorDescription ?? ""

        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: Localization.ok, style: .default) { [weak self] _ in
            guard let self else { return }

            if let error {
                self.handleErrorPushDeploymentIdMismatch(error: error)
            }
        }

        okAlertAction.accessibilityIdentifier = "errorAlertOkButton"
        alert.addAction(okAlertAction)
        present(alert, animated: true)
    }

    private func handleErrorPushDeploymentIdMismatch(error: GCError) {
        if error.errorType == .pushDeploymentIdMismatch {
            var account: MessengerAccount?
            if let savedPushDeploymentId = UserDefaults.pushDeploymentId, let savedPushDomain = UserDefaults.pushDomain {
                account = MessengerAccount(deploymentId: savedPushDeploymentId,
                                           domain: savedPushDomain,
                                           logging: self.loggingSwitch.isOn)
            } else {
                account = self.createAccountForValidInputFields()
            }

            pushManager.removeFromPushNotifications(account: account, deploymentId: deploymentIdTextField.text)
        }
    }

    private func showNotificationSettingsAlert() {
        let alertController = UIAlertController(
            title: Localization.notificationsDisabled,
            message: Localization.enableNotifications,
            preferredStyle: .alert
        )

        alertController.addAction(UIAlertAction(title: Localization.cancel, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: Localization.settings, style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        })

        present(alertController, animated: true)
    }
}

enum AccountDetailsError: Error {
    case pushDisabled
    case error(error: GCError)
}
