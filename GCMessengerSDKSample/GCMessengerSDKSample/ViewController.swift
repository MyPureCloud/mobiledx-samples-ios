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
        meesengerAccount.deploymentId = "f8aad9d7-f8e7-48e9-ab02-eef92bc4fd2f"
        meesengerAccount.domain = "inindca.com"
        meesengerAccount.tokenStoreKey = "com.genesys.cloud.messenger"
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



