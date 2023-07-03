// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud

class ChatWrapperViewController: UIViewController {
    let wrapperActivityView = UIActivityIndicatorView(style: .large)
    let chatViewControllerActivityView = UIActivityIndicatorView(style: .large)

    var chatController: ChatController!
    var messengerAccount = MessengerAccount()
    var chatState: ChatState?

    override func viewDidLoad() {
        super.viewDidLoad()
        chatController = ChatController(account: messengerAccount)
        chatController.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSpinner(activityView: wrapperActivityView, view: view)
    }

    @objc func dismissChat(_ sender: UIBarButtonItem?) {
        chatController.terminate()
        presentingViewController?.dismiss(animated: true)
    }
    
    func startSpinner(activityView: UIActivityIndicatorView) {
        activityView.startAnimating()
    }
    
    func stopSpinner(activityView: UIActivityIndicatorView) {
        activityView.stopAnimating()
    }
    
    func setSpinner(activityView: UIActivityIndicatorView, view: UIView?) {
        activityView.frame = view?.frame ?? .zero
        activityView.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        activityView.center = view?.center ?? .zero
        
        activityView.hidesWhenStopped = true
        
        view?.addSubview(activityView)
    }
}

extension ChatWrapperViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        if self.chatState == .prepared {
            self.present(viewController, animated: true) {
                viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "End Chat", style: .plain, target: self, action: #selector(ChatWrapperViewController.dismissChat(_:)))
                self.setSpinner(activityView: self.chatViewControllerActivityView, view: viewController.viewControllers.first?.view)
            }
        }
    }

    func didFailWithError(_ error: GCError?) {
        if let error = error {
            if let errorDescription = error.errorDescription {
                print("Error: \(errorDescription)")
            }

            switch error.errorType {
            case .failedToLoad:
                self.dismissChat(nil)
                if let errorDescription = error.errorDescription {
                    Toast.show(message: "Error: \(errorDescription)")
                }
            case .failedMessengerChatErrorDisableState:
                if let errorDescription = error.errorDescription {
                    let alert = UIAlertController(title: "Error occurred", message: errorDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                        self?.dismissChat(nil)
                    }))
                    
                    if let topViewController = UIApplication.getTopViewController() {
                        topViewController.present(alert, animated: true)
                    }
                }                
            case .failedToSendMessage:
                print("** CAN'T SEND MESSAGE: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    Toast.show(message: errorDescription)
                }
            default:
                break
            }
        }
    }
    
    func didUpdateState(_ event: ChatStateEvent!) {
        print("Chat state: \(event.state)")
        self.chatState = event.state
        
        switch event.state {
        case .preparing:
            print("preparing")
            startSpinner(activityView: wrapperActivityView)
            startSpinner(activityView: chatViewControllerActivityView)
        case .started:
            print("started")
            stopSpinner(activityView: chatViewControllerActivityView)
        case .disconnected:
            
//            let alert = UIAlertController(title: "Chat was disconnected", message: "We were not able to restore chat connection.\nMake sure your device is connected.\nWould you like to continue with the chat or dismiss it?", preferredStyle: .alert)

            let alert = UIAlertController(title: "Chat was disconnected", message: "We were not able to restore chat connection.\nMake sure your device is connected.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Reconnect Chat", style: .default, handler: { _ in
                self.chatController.reconnectChat()
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss Chat", style: .cancel, handler: { _ in
                self.dismissChat(nil)
            }))
            
            if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alert, animated: true)
            }

        default:
            print(event.state)
        }
    }
    
    func didClickLink(_ url: String) {
        print("Link \(url) was pressed in the chat")
    }
}
