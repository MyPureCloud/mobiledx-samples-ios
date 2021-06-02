// ===================================================================================================
// Copyright © 2021 bold360(Genesys).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class ViewController: UIViewController {
// Setup Chat
    var chatController: ChatController!
    var account = BotAccount()
    var chatVC: UINavigationController!
    @IBOutlet weak var printTranscriptBtn: UIButton!
    
    // Transcript Handler
    var transcriptHandler = TranscriptHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        let botAccount = BotAccount()
        botAccount.account = "nanorep"
        botAccount.knowledgeBase = "English"
        botAccount.perform(Selector.init(("setServer:")), with:"mobilestaging")
        self.chatController = ChatController(account: botAccount)
        chatController.delegate = self
        chatController.chatElementDelegate = self.transcriptHandler as ChatElementDelegate
    }
    
    @IBAction func printTranscrip(_ sender: Any) {
        print(transcriptHandler.transcript!)
    }
}

// Show Chat
extension ViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        self.show(viewController, sender: self)
        
        // EndChat button attachment
        viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(ViewController.dismissChat(_:)))
    }
    
    func didFailWithError(_ error: BLDError!) {
    }
    
    @objc func dismissChat(_ sender: UIBarButtonItem?) {
        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: {
            self.chatController.terminate()
            self.navigationController?.popViewController(animated: true)
            self.printTranscriptBtn.isHidden = false
        })
    }
}
