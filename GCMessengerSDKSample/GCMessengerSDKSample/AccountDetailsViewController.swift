// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit
import GenesysCloud
import GenesysCloudMessenger

class AccountDetailsViewController: UIViewController {
    @IBOutlet weak var deploymentIdTextField: UITextField!
    @IBOutlet weak var domainIdTextField: UITextField!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var loggingSwitch: UISwitch!
    @IBOutlet weak var versionAndBuildLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionAndBuildLabel.text = "Version: \(versionNumber), Build: \(buildNumber)"
        }
        
        deploymentIdTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        domainIdTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            if deploymentId.isEmpty && domainId.isEmpty {
                startChatButton.isEnabled = false
            }
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let deploymentId = deploymentIdTextField.text, let domainId = domainIdTextField.text {
            startChatButton.isEnabled = !deploymentId.isEmpty && !domainId.isEmpty
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupFields() {
        deploymentIdTextField.text = UserDefaults.deploymentId
        domainIdTextField.text = UserDefaults.domainId
        
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
                    Toast.show(message: "Chat availability status returned \(result.isAvailable)", backgroundColor: result.isAvailable ? UIColor.green : UIColor.red)
                }
            })
        }
    }
    
    private func createAccountForValidInputFields() -> MessengerAccount? {
        if deploymentIdTextField.text?.isEmpty == true || domainIdTextField.text?.isEmpty == true {
            markInvalidTextFields(requiredTextFields: [deploymentIdTextField, domainIdTextField])
            
            showErrorAlert()
            return nil
        } else {
            let account = MessengerAccount(deploymentId: deploymentIdTextField.text ?? "",
                                           domain: domainIdTextField.text ?? "",
                                           logging: loggingSwitch.isOn)
            
            
            addCustomAttributes(account: account)
            
            updateUserDefaults()
            return account
        }
    }
    
    private func addCustomAttributes(account: MessengerAccount) {
        var customAttributes = [String: String]()
        customAttributes["username"] = "guest"
        
        account.customAttributes = customAttributes
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: nil, message: "One or more required fields needed, please check & try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func markInvalidTextFields(requiredTextFields: [UITextField]) {
        for field in requiredTextFields {
            if field.text?.isEmpty == true {
                field.isError(baseColor: UIColor.red.cgColor, numberOfShakes: 3, revert: true)
            }
        }
    }
        
    private func updateUserDefaults() {
        UserDefaults.deploymentId = deploymentIdTextField.text ?? ""
        UserDefaults.domainId = domainIdTextField.text ?? ""
        UserDefaults.logging = loggingSwitch.isOn
    }
    
    private func openMainController(with account: MessengerAccount) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatWrapperViewController") as! ChatWrapperViewController
        controller.messengerAccount = account
        
        present(controller, animated: true)
    }
}
