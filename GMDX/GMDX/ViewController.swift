//
//  ViewController.swift
//  DXSample
//
//  Created by Eliza Koren on 28/10/2021.
//

import UIKit
import Bold360AI

class ViewController: UIViewController {

    var chatController: ChatController!
    var account = LiveAccount()
    var chatVC: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let meesengerAccount = MessengerAccount()
        meesengerAccount.deploymentId = "f8aad9d7-f8e7-48e9-ab02-eef92bc4fd2f"
        meesengerAccount.domain = "inindca.com"
        meesengerAccount.tokenStoreKey = "com.genesys.cloud.messenger"
//        meesengerAccount.logging.pointee.boolValue = true
        
//        let botAccount = BotAccount()
//        botAccount.account = "nanorep"
//        botAccount.knowledgeBase = "English"
//        botAccount.perform(Selector.init(("setServer:")), with:"mobileStaging")
//         self.chatController = ChatController(account: botAccount)
        
        
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = .white
//        self.account.apiKey = "2300000001700000000:2279740578451875484:w+8/nRppLqulxknuMDWbiwyAbWbNgv/Y:gamma"
        
        self.chatController = ChatController(account: meesengerAccount)
        chatController.delegate = self
    }
    
    @objc func dismissChat(_ sender: UIBarButtonItem?) {
        self.chatController.terminate()
//        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: {
//            self.chatController.terminate()
//            self.navigationController?.popViewController(animated: true)
//        })
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
    }
}

