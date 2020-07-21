// ===================================================================================================
// Copyright © 2020 testApp(LogMeIn).
// Bold360AI SDK usage.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class ViewController: UIViewController {

    var chatController: ChatController!
    var account = BotAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.account.account = ""
        self.account.knowledgeBase = ""
        self.account.apiKey = ""
        self.chatController = ChatController(account: self.account)
        self.chatController.delegate = self
    }
}

extension ViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        DispatchQueue.main.async {
           viewController.modalPresentationStyle = .fullScreen
           self.navigationController?.present(viewController, animated: false, completion: nil)
        }
    }
    
    func didFailWithError(_ error: BLDError!) {
        print(error.description)
    }
}

