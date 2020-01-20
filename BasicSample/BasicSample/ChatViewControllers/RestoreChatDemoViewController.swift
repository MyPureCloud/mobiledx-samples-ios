// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class RestoreChatDemoViewController: AgentViewController {

    var restoreChat: RestoreChat?
    var alert: UIAlertController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.restoreChat = RestoreChat(appDelegate.persistentContainer.viewContext)
            self.restoreChat?.groupId = "RestoreChatDemoViewController"
            self.restoreChat?.delegate = self
            self.chatController.chatElementDelegate = self.restoreChat
        }
    }
    
    override func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        super.shouldPresentChatViewController(viewController)
        self.restoreChat?.state = .prsented
    }
    
    override func dismissChat(_ sender: UIBarButtonItem?) {
        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: {
            self.alert = UIAlertController(title: "Background Message", message: "Please wait for the agent's message", preferredStyle: .alert)
            self.alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(self.alert, animated: true, completion: nil)
        })
        self.restoreChat?.state = .dismissed
        
    }
    
    func presentMessageAlert(_ message: StorableChatElement) {
        let alert = UIAlertController(title: "Agent Message", message: message.text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Load Chat", style: .default, handler: { _ in
            self.chatController.restoreChatViewController()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RestoreChatDemoViewController: RestoreChatDelegate {
    func didReceiveBackgroundMessage(_ message: StorableChatElement) {
        self.alert.dismiss(animated: true) {
            self.presentMessageAlert(message)
        }
    }
}

