// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud

class ChatWrapperViewController: UIViewController {
    let activityView = UIActivityIndicatorView(style: .large)
    
    var chatController: ChatController!
    var chatVC: UINavigationController!
    var messengerAccount = MessengerAccount()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatController = ChatController(account: messengerAccount)
        chatController.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSpinner()
    }

    @objc func dismissChat(_ sender: UIBarButtonItem?) {
        self.chatController.terminate()
        presentingViewController?.dismiss(animated: true)
    }
    
    func startSpinner() {
        activityView.startAnimating()
    }
    
    func stopSpinner() {
        activityView.stopAnimating()
    }
    
    func setSpinner() {
        activityView.frame = view.frame
        activityView.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        activityView.center = view.center
        
        activityView.hidesWhenStopped = true
        
        view.addSubview(activityView)
    }
}

extension ChatWrapperViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true) { () -> Void in
            viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "End Chat", style: .plain, target: self, action: #selector(ChatWrapperViewController.dismissChat(_:)))
            
        }
    }

    func didFailWithError(_ error: BLDError!) {
        let alert = UIAlertController(title: "Error occurred", message: "Please Check Details & try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismissChat(nil)
        }))
        present(alert, animated: true)
    }
    
    func didUpdateState(_ event: ChatStateEvent!) {
        print("Chat state: \(event.state)")
        
        switch event.state {
        case .preparing:
            print("preparing")
            startSpinner()
        case .started:
            print("started")
        default:
            print(event.state)
        }
    }
    
}



