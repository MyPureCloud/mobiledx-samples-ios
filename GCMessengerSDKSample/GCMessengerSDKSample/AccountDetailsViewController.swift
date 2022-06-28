//
//  AccountDetailsViewController.swift
//  GCMessengerSDKSample
//
//  Created by Golan Shoval Gil on 26/06/2022.
//

import Foundation
import UIKit
import GenesysCloud

class AccountDetailsViewController: UIViewController {
    @IBOutlet weak var deploymentIdTextField: UITextField!
    @IBOutlet weak var domainIdTextField: UITextField!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var startChatButton: UIButton!
    @IBOutlet weak var loggingSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFields()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupFields() {
        deploymentIdTextField.placeholder = "Deployment id"
        deploymentIdTextField.text = UserDefaults.deploymentId

        domainIdTextField.placeholder = "Domain id"
        domainIdTextField.text = UserDefaults.domainId
        
        tokenTextField.placeholder = "Token store id"
        tokenTextField.text = UserDefaults.token
        
        loggingSwitch.setOn(UserDefaults.logging, animated: true)
    }

    @IBAction func startChatButtonTapped(_ sender: UIButton) {
        
        let account = MessengerAccount(deploymentId: deploymentIdTextField.text ?? "",
                                       domain: domainIdTextField.text ?? "",
                                       tokenStoreKey: tokenTextField.text ?? "",
                                       logging: loggingSwitch.isOn)
        
        updateUserDefaults()
        openMainController(with: account)
    }
    
    private func updateUserDefaults() {
        UserDefaults.deploymentId = deploymentIdTextField.text ?? ""
        UserDefaults.domainId = domainIdTextField.text ?? ""
        UserDefaults.token = tokenTextField.text ?? ""
        UserDefaults.logging = loggingSwitch.isOn
    }
    
    private func openMainController(with account: MessengerAccount) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatWrapperViewController") as! ChatWrapperViewController
        controller.messengerAccount = account
        
        present(controller, animated: true)
    }
}
