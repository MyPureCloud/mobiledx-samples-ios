// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class AgentViewController: BotDemoViewController, AccountProvider {
    var accountExtraData = AccountExtraData()
    
    var liveAccount = LiveAccount()
    
    override func createAccount() -> Account {
        liveAccount = LiveAccount()
        liveAccount.apiKey = "2300000001700000000:2279145895771367548:MGfXyj9naYgPjOZBruFSykZjIRPzT1jl"
       
        liveAccount.extraData.setExtraParams(["initial_question":"why?","first_name":"eliza","address":"ADDRESS", "email":"w@w.com"])
        // Oz account
//        liveAccount.apiKey = "2300000001700000000:2278936004449775473:sHkdAhpSpMO/cnqzemsYUuf2iFOyPUYV"
        return liveAccount
    }
    
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
