//
//  EmbedDemoViewController.swift
//  BasicSample
//
//  Created by Nissim on 29/07/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit

class EmbedDemoViewController: BotDemoViewController {
    @IBOutlet weak var chatContainer: UIView!
    
    override func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.isNavigationBarHidden = true
        self.addChild(viewController)
        viewController.view.frame = self.chatContainer.bounds
        self.chatContainer.addSubview(viewController.view)
    }
}
