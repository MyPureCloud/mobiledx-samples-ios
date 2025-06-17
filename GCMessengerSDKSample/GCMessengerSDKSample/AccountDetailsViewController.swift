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
    
    private var authCode: String?
    private var codeVerifier: String?
    private var signInRedirectURI: String?
    
    private var pushProvider: PushProvider = .apns
    
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
        
        deploymentIdTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        domainIdTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setButtonsAvailability()
        
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
        setButtonsAvailability()
        setPushNotificationsViews()
    }

    func setButtonsAvailability() {
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            let domainAndDeploymentIdsAreEmpty = deploymentId.isEmpty && domainId.isEmpty
            startChatButton.isEnabled = !domainAndDeploymentIdsAreEmpty
            pushButton.isEnabled = !domainAndDeploymentIdsAreEmpty
        }
    }
    
    func setPushNotificationsViews() {
        guard let deploymentId = deploymentIdTextField.text else {
            NSLog("Can't get deployment ID")
            return
        }
        
        let pushProvider = UserDefaults.getPushProviderFor(deploymentId: deploymentId)
        let pushButtonTitle = pushProvider == nil ? "ENABLE PUSH" : "DISABLE PUSH"
        pushButton.setTitle(pushButtonTitle, for: .normal)
        
        if pushProvider != nil {
            pushProviderToggle.selectedSegmentIndex = pushProvider == "apns" ? 0 : 1
        }
        
        pushProviderToggle.isEnabled = pushProvider == nil
        self.pushProvider = pushProviderToggle.selectedSegmentIndex == 0 ? .apns : .fcm
    }

    @IBAction func pushButtonTapped(_ sender: Any) {
        guard let deploymentId = deploymentIdTextField.text else {
            NSLog("Can't get deployment ID")
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupFields() {
        deploymentIdTextField.text = UserDefaults.deploymentId
        domainIdTextField.text = UserDefaults.domainId
        customAttributesTextField.text = UserDefaults.customAttributes
        
        loggingSwitch.setOn(UserDefaults.logging, animated: true)
    }
    
    @IBAction func startChatButtonTapped(_ sender: UIButton) {
        if let account = createAccountForValidInputFields() {
            openMainController(with: account)
        }
    }
    
    @IBAction func chatAvailabilityButtonTapped(_ sender: UIButton) {
        if let account = createAccountForValidInputFields() {
            ChatAvailabilityChecker.checkAvailability(account, completion: { result in
                if let result {
                    ToastManager.shared.showToast(message: "Chat availability status returned \(result.isAvailable)", backgroundColor: result.isAvailable ? UIColor.green : UIColor.red)
                }
            })
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        controller.modalPresentationCapturesStatusBarAppearance = true
        present(controller, animated: true)
    }
}

// MARK: Handle Authentication
extension AccountDetailsViewController: AuthenticationViewControllerDelegate, ChatWrapperViewControllerDelegate {
    func authenticationSucceeded(authCode: String, redirectUri: String, codeVerifier: String?) {
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
        dismiss(animated: true, completion: {
            let alert = UIAlertController(title: "Error occurred", message: message, preferredStyle: .alert)
            
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
        removeSavedPushDeploymentId {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                DispatchQueue.main.async {
                    if granted {
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                            return
                        }
                        
                        printLog("Register for remote notifications")
                        self.pushProvider == .apns ? appDelegate.registerForAPNsRemoteNotifications() : appDelegate.registerForFCMRemoteNotifications()
                    } else {
                        printLog("Notifications Disabled")
                        self.showNotificationSettingsAlert()
                    }
                }
            }
        }
    }
    
    private func removeSavedPushDeploymentId(completion: (@escaping () -> Void)) {
        if let savedPushDeploymentId = UserDefaults.pushDeploymentId, let savedPushDomain = UserDefaults.pushDomain {
            let account = MessengerAccount(deploymentId: savedPushDeploymentId,
                                           domain: savedPushDomain,
                                           logging: loggingSwitch.isOn)
            
            removeFromPushNotifications(account: account, completion: completion)
        } else {
            completion()
        }
    }
    
    private func removeFromPushNotifications(account: MessengerAccount? = nil, completion: (() -> Void)? = nil) {
        let accountToUse: MessengerAccount
            
        if let providedAccount = account {
            accountToUse = providedAccount
        } else if let createdAccount = createAccountForValidInputFields() {
            accountToUse = createdAccount
        } else {
            NSLog("Error: can't create account from input fields")
            return
        }

        startSpinner(activityView: wrapperActivityView)
        ChatPushNotificationIntegration.removePushToken(account: accountToUse, completion: { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                guard let deploymentId = self.deploymentIdTextField.text else {
                    NSLog("Can't get deployment ID")
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
            NSLog("Error: push provider selection error")
            return
        }
        
        startSpinner(activityView: wrapperActivityView)
        
        ChatPushNotificationIntegration.setPushToken(deviceToken: deviceToken, pushProvider: pushProvider, account: account, completion: { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

                self.stopSpinner(activityView: self.wrapperActivityView)
                
                guard let deploymentId = self.deploymentIdTextField.text, let domain = self.domainIdTextField.text else {
                    NSLog("Can't get deployment ID or domain")
                    return
                }

                switch result {
                case .success:
                    self.setRegistrationFor(deploymentId: deploymentId, pushProvider: pushProvider)
                    UserDefaults.pushDeploymentId = deploymentId
                    UserDefaults.pushDomain = domain
                    ToastManager.shared.showToast(message: "Push Notifications are ENABLED")
                    NSLog("\(pushProvider) was registered with device token \(deviceToken)")
                case .failure(let error):
                    let errorText = error.errorDescription ?? String(describing: error.errorType)
                    if errorText == "Device already registered." {
                        self.setRegistrationFor(deploymentId: deploymentId, pushProvider: pushProvider)
                    }
                    self.showErrorAlert(message: "\(errorText), Device Token: \(deviceToken)")
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
        
        return (account, deviceToken?.lowercased())
    }
    
    func setRegistrationFor(deploymentId: String, pushProvider: PushProvider) {
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
