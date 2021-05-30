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
        chatController.chatElementDelegate = self
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

extension ViewController: ChatElementDelegate {
    func didReceive(_ item: StorableChatElement!) {
        var prefix = "";
        
        switch item.type {
        case .OutgoingElement:
            prefix = "END_USER: "
            break
        case .IncomingLiveElement:
            prefix = "LIVE: "
            break
        case .IncomingBotElement,
             .CarouselElement,
             .IncomingBotMultipleSelectionElement:
            prefix = "BOT: "
            break
        case .SystemMessageElement:
            prefix = "SYSTEM: "
            break
        default:
            break
        }
        
        self.transcriptHandler.addMessage(prefix + item.text!)
    }
}
