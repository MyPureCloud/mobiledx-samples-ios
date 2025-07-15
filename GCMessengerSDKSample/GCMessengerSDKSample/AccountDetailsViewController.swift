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
        
        
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            if deploymentId.isEmpty && domainId.isEmpty {
                startChatButton.isEnabled = false
            }
        }
        
        loginButton.setTitle("LOGIN", for: .normal)
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
            startChatButton.isEnabled = !deploymentId.isEmpty && !domainId.isEmpty
        }
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
                
                self.loginButton.isHidden = !shouldAuthorize
            })
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupFields() {
        deploymentIdTextField.delegate = self
        deploymentIdTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        deploymentIdTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        domainIdTextField.delegate = self
        domainIdTextField.addTarget(self, action: #selector(textFieldEditingDidChange(_:)), for: .editingChanged)
        domainIdTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        
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
        controller.isAuthorized = loginButton.isHidden || authCode != nil
        controller.modalPresentationStyle = .fullScreen
        controller.modalPresentationCapturesStatusBarAppearance = true
        present(controller, animated: true)
    }
}

extension AccountDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

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
            alert.view.accessibilityIdentifier = "alert_view"

            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                self.loginButton.isEnabled = true
            }))
            
            if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alert, animated: true)
            }
        })
    }
    
    func didLogout() {
        self.authCode = nil
        self.signInRedirectURI = nil
        self.codeVerifier = nil
        
    }
}
