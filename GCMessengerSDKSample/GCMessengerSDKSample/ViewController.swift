// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud

class ViewController: UIViewController {

    var chatController: ChatController!
    var chatVC: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let meesengerAccount = MessengerAccount()
        meesengerAccount.deploymentId = {DEPLOYMENT_ID} //Please replace {DEPLOYMENT_ID}
        meesengerAccount.domain = {DOMAIN} //Please replace {DOMAIN}
        meesengerAccount.tokenStoreKey = {TOKEN_STORE_KEY} //Please replace {TOKEN_STORE_KEY} 
        self.chatController = ChatController(account: meesengerAccount)
        chatController.delegate = self
    }

    @objc func dismissChat(_ sender: UIBarButtonItem?) {
        self.chatController.terminate()
    }
}

extension ViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true) { () -> Void in
            viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "End Chat", style: .plain, target: self, action: #selector(ViewController.dismissChat(_:)))
        }
    }

    func didFailWithError(_ error: BLDError!) {
        NSLog(error.error.debugDescription);
    }
}



