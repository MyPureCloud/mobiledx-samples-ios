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
    private var shouldAuthorize = false
    
    private var pushProvider: GenesysCloud.PushProvider = .apns
    private var isRegisteredToPushNotifications = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
           let transportVersionNumber = Bundle(for: MessengerTransportSDK.self).infoDictionary?["CFBundleShortVersionString"] as? String,
           let transportBuildNumber = Bundle(for: MessengerTransportSDK.self).infoDictionary?["CFBundleVersion"] as? String
        {
            versionAndBuildLabel.text = "Version: \(versionNumber), Build: \(buildNumber), Transport: \(transportVersionNumber).\(transportBuildNumber)"
        }
        
        loginButton.setTitle("LOGIN", for: .normal)
        
        setPushNotificationsViews()
        registerForNotificationsObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSpinner(activityView: wrapperActivityView, view: view)
    }
    
    func setSpinner(activityView: UIActivityIndicatorView, view: UIView?) {
        activityView.frame = view?.frame ?? .zero
        activityView.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        activityView.center = view?.center ?? .zero
        
        activityView.hidesWhenStopped = true
        
        view?.addSubview(activityView)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        setPushNotificationsViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard checkInputFieldIsValid(deploymentIdTextField) || checkInputFieldIsValid(domainIdTextField) else {
            return
        }

        setLoginButtonVisibility()
    }
    
    @objc func textFieldEditingDidChange(_ textField: UITextField) {
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            let domainAndDeploymentIdsAreEmpty = deploymentId.isEmpty && domainId.isEmpty
            startChatButton.isEnabled = !domainAndDeploymentIdsAreEmpty
            pushButton.isEnabled = !domainAndDeploymentIdsAreEmpty
        }
    }
    
    func setPushNotificationsViews() {
        guard let deploymentId = deploymentIdTextField.text else {
            GCLogger.error("Deployment ID not available")
            return
        }
        
        let pushProvider = UserDefaults.getPushProviderFor(deploymentId: deploymentId)
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
        guard let deploymentId = deploymentIdTextField.text else {
            GCLogger.error("Deployment ID not available")
            return
        }
        
        if UserDefaults.getPushProviderFor(deploymentId: deploymentId) != nil {
            removeFromPushNotifications()
        } else {
            registerForPushNotifications()
        }
    }
    
    @IBAction func pushProviderToggleChanged(_ sender: UISegmentedControl) {
        pushProvider = sender.selectedSegmentIndex == 0 ? .apns : .fcm
    }
    
    @objc func loggingSwitchChanged(_ sender: UISwitch) {
        // Update both UserDefaults and GCLogger immediately
        UserDefaults.logging = sender.isOn
        GCLogger.isLoggingEnabled = sender.isOn
    }
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
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
        loggingSwitch.addTarget(self, action: #selector(loggingSwitchChanged(_:)), for: .valueChanged)
        
        // Initialize GCLogger with the current logging state
        GCLogger.isLoggingEnabled = UserDefaults.logging
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
                    GCLogger.error("Invalid account: required fields missing")
                }
            })
        }
    }
    
    @IBAction func chatAvailabilityButtonTapped(_ sender: UIButton) {
        if let account = createAccountForValidInputFields() {
            ChatAvailabilityChecker.checkAvailability(account) { isAvailable in
                ToastManager.shared.showToast(message: isAvailable ? "Chat is ENABLED" : "Chat is DISABLED", backgroundColor: isAvailable ? UIColor.green : UIColor.red)
            }
        }
    }
    
    @IBAction func OnLoginTapped(_ sender: Any) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationViewController") as! AuthenticationViewController
        controller.modalPresentationCapturesStatusBarAppearance = true
        controller.delegate = self
        present(controller, animated: true)
    }
    
    private func checkInputFieldIsValid(_ inputField: UITextField) -> Bool {
        if inputField.text?.isEmpty == true {
            markInvalidTextField(inputField)
            return false
        }
        return true
    }
    
    private func createAccountForValidInputFields() -> MessengerAccount? {
        guard checkInputFieldIsValid(deploymentIdTextField) || checkInputFieldIsValid(domainIdTextField) else {
            showErrorAlert(message: "One or more required fields needed, please check & try again")
            return nil
        }
        
        let account = MessengerAccount(deploymentId: deploymentIdTextField.text ?? "",
                                       domain: domainIdTextField.text ?? "",
                                       logging: loggingSwitch.isOn)
        
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
        if error.errorType == .pushDeploymentIdMismatch {
            var account: MessengerAccount?
            if let savedPushDeploymentId = UserDefaults.pushDeploymentId, let savedPushDomain = UserDefaults.pushDomain {
                account = MessengerAccount(deploymentId: savedPushDeploymentId,
                                           domain: savedPushDomain,
                                           logging: self.loggingSwitch.isOn)
            } else {
                account = self.createAccountForValidInputFields()
            }
            
            self.removeFromPushNotifications(account: account, completion: nil)
        }
    }


    private func markInvalidTextField(_ requiredTextField: UITextField) {
        requiredTextField.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
    }
    
    private func updateUserDefaults() {
        UserDefaults.deploymentId = deploymentIdTextField.text ?? ""
        UserDefaults.domainId = domainIdTextField.text ?? ""
        UserDefaults.logging = loggingSwitch.isOn
        UserDefaults.customAttributes = customAttributesTextField.text ?? ""
    }
    
    private func openMainController(with account: MessengerAccount) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatWrapperViewController") as! ChatWrapperViewController
        controller.delegate = self
        controller.messengerAccount = account
        controller.isAuthorized = shouldAuthorize || UserDefaults.hasOktaCode
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
        DispatchQueue.main.async { [weak self] in
            if let topViewController = UIApplication.getTopViewController(), topViewController is AccountDetailsViewController {
                let alertController = UIAlertController(
                    title: "New Message Arrived",
                    message: chatElement.getText(),
                    preferredStyle: .alert
                )
                    
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                guard let self else { return }
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
    
    func authenticationSucceeded(authCode: String, redirectUri: String, codeVerifier: String?) {
        UserDefaults.hasOktaCode = true
        self.authCode = authCode
        self.signInRedirectURI = redirectUri
        self.codeVerifier = codeVerifier
        
        dismiss(animated: true, completion: nil)
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
}

// MARK: Handle push notifications registration
extension AccountDetailsViewController {
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                        return
                    }
                    
                    GCLogger.info("Registering for remote notifications")
                    self.pushProvider == .apns ? appDelegate.registerForAPNsRemoteNotifications() : appDelegate.registerForFCMRemoteNotifications()
                } else {
                    GCLogger.warning("Notifications disabled by user")
                    self.showNotificationSettingsAlert()
                }
            }
        }
    }
    
    private func removeFromPushNotifications(account: MessengerAccount? = nil, completion: (() -> Void)? = nil) {
        let accountToUse: MessengerAccount
        
        if let providedAccount = account {
            accountToUse = providedAccount
        } else if let createdAccount = createAccountForValidInputFields() {
            accountToUse = createdAccount
        } else {
            GCLogger.error("Cannot create account from input fields")
            return
        }
        
        startSpinner(activityView: wrapperActivityView)
        ChatPushNotificationIntegration.removePushToken(account: accountToUse, completion: { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                guard let deploymentId = self.deploymentIdTextField.text else {
                    GCLogger.error("Deployment ID not available")
                    return
                }
                
                self.stopSpinner(activityView: self.wrapperActivityView)
                switch result {
                case .success:
                    UserDefaults.setPushProviderFor(deploymentId: deploymentId, pushProvider: nil)
                    UserDefaults.pushDeploymentId = nil
                    UserDefaults.pushDomain = nil
                    
                    self.setPushNotificationsViews()
                    ToastManager.shared.showToast(message: "Pusn Notifications are DISABLED")
                case .failure(let error):
                    let errorText = error.errorDescription ?? String(describing: error.errorType)
                    self.showErrorAlert(message: "\(errorText), Deployment ID: \(deploymentId)")
                }
                completion?()
            }
        })
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
    
    @objc func handleDeviceToken(_ notification: Notification) {
        let (account, deviceToken) = getAccountAndDeviceToken(notification)
        guard let account, let deviceToken else {
            GCLogger.error("Push provider selection failed")
            return
        }
        
        startSpinner(activityView: wrapperActivityView)
        
        ChatPushNotificationIntegration.setPushToken(deviceToken: deviceToken, pushProvider: pushProvider, account: account, completion: { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                self.stopSpinner(activityView: self.wrapperActivityView)
                
                guard let deploymentId = self.deploymentIdTextField.text, let domain = self.domainIdTextField.text else {
                    GCLogger.error("Deployment ID or domain not available")
                    return
                }
                
                switch result {
                case .success:
                    self.setRegistrationFor(deploymentId: deploymentId, pushProvider: pushProvider)
                    UserDefaults.pushDeploymentId = deploymentId
                    UserDefaults.pushDomain = domain
                    ToastManager.shared.showToast(message: "Push Notifications are ENABLED")
                    GCLogger.info("Push provider registered: \(public: pushProvider)")
                case .failure(let error):
                    let errorText = error.errorDescription ?? String(describing: error.errorType)
                    if errorText == "Device already registered." {
                        self.setRegistrationFor(deploymentId: deploymentId, pushProvider: pushProvider)
                    }
                    self.showErrorAlert(error: error)
                }
            }
        })
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
                GCLogger.error("APNS device token not found")
                return (nil, nil)
            }
            deviceToken = apnsToken
        } else if pushProvider == .fcm {
            guard let fcmToken = userInfo["fcmToken"] as? String else {
                GCLogger.error("FCM device token not found")
                return (nil, nil)
            }
            
            deviceToken = fcmToken
        }
        
        return (account, deviceToken)
    }
    
    func setRegistrationFor(deploymentId: String, pushProvider: GenesysCloud.PushProvider) {
        let pushProviderString = pushProvider == .apns ? "apns" : "fcm"
        UserDefaults.setPushProviderFor(deploymentId: deploymentId, pushProvider: pushProviderString)
        self.setPushNotificationsViews()
    }
}

// MARK: Handle receiving notifications
extension AccountDetailsViewController {
    private func registerForNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceToken(_:)), name: Notification.Name.deviceTokenReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationReceived(_:)), name: Notification.Name.notificationReceived, object: nil)
    }
    
    @objc func handleNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo else {
            GCLogger.error("Notification userInfo empty")
            return
        }
        
        guard UIApplication.shared.applicationState == .active else {
            GCLogger.debug("App not in foreground")
            return
        }
        
        guard let senderID = userInfo["deeplink"] as? String else {
            GCLogger.warning("Sender ID not found in notification")
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
            GCLogger.error("Failed to retrieve notification userInfo")
        }
    }
    
    func didLogout() {
        UserDefaults.hasOktaCode = false
        self.authCode = nil
        self.signInRedirectURI = nil
        self.codeVerifier = nil
        self.chatWrapperViewController = nil
    }
}
