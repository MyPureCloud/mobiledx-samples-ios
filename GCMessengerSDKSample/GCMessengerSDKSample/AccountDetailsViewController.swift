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

class AccountDetailsViewController: UIViewController {
    @IBOutlet weak var deploymentIdTextField: UITextField!
    @IBOutlet weak var domainIdTextField: UITextField!
    @IBOutlet weak var customAttributesTextField: UITextField!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var loggingSwitch: UISwitch!
    @IBOutlet weak var versionAndBuildLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!
    
    private var authCode: String?
    private var codeVerifier: String?
    private var signInRedirectURI: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
           let transportVersion = Bundle(for: MessengerTransportSDK.self).infoDictionary?["CFBundleVersion"] as? String {
            versionAndBuildLabel.text = "Version: \(versionNumber), Build: \(buildNumber), Transport: \(transportVersion)"
        }
        
        deploymentIdTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        domainIdTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setButtonsAvailability()
        
        loginButton.setTitle("LOGIN", for: .normal)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        setButtonsAvailability()
    }

    func setButtonsAvailability() {
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            let domainAndDeploymentIdsAreEmpty = deploymentId.isEmpty && domainId.isEmpty
            startChatButton.isEnabled = !domainAndDeploymentIdsAreEmpty
            pushButton.isEnabled = !domainAndDeploymentIdsAreEmpty
        }
    }

    @IBAction func pushButtonTapped(_ sender: Any) {
        registerForPushNotifications()
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
}

// MARK: Handle push notifications
extension AccountDetailsViewController {
    private func registerForPushNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceToken(_:)), name: Notification.Name.deviceTokenReceived, object: nil)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    printLog("Register for Apple remote notifications")
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    printLog("Notifications Disabled")
                    self.showNotificationSettingsAlert()
                }
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
    
    @objc func handleDeviceToken(_ notification: Notification) {
        guard let deviceToken = notification.object as? String else {
            printLog("Error: no device token", logType: .failure)
            return
        }
        
        printLog("Device token: \(deviceToken)")
        
        guard let account = self.createAccountForValidInputFields() else {
            printLog("Error: can't create account", logType: .failure)
            return
        }
        
        //TODO:: [GMMS-8034] Call setPushToken
//        ChatPushIntegration.setPushToken(deviceToken: deviceToken, pushProvider: .apns, account: account, completion: {
//                
//        })
    }
}
