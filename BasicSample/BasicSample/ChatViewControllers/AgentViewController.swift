// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class AgentViewController: BotDemoViewController, AccountProvider {
    var accountExtraData = AccountExtraData()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatController.accountProvider = self
        // Do any additional setup after loading the view.
    }
    
    @objc func endChat(_ sender: UIBarButtonItem) {
        self.chatController.endChat()
    }
    
    override func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        super.shouldPresentChatViewController(viewController)
//        viewController.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "End Chat", style: .plain, target: self, action: #selector(AgentViewController.endChat(_:)))
    }
}
