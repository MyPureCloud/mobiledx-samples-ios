// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud
import GenesysCloudMessenger

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
        DispatchQueue.main.async {
            activityView.startAnimating()
        }
    }
    
    func stopSpinner(activityView: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityView.stopAnimating()
        }
    }
    
    func setSpinner(activityView: UIActivityIndicatorView, view: UIView?) {
        activityView.frame = view?.frame ?? .zero
        activityView.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        activityView.center = view?.center ?? .zero
        
        activityView.hidesWhenStopped = true
        
        view?.addSubview(activityView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

extension ChatWrapperViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        if self.chatState == .chatPrepared {
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
                    ToastManager.shared.showToast(message: "\(errorDescription)")
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
                    ToastManager.shared.showToast(message: errorDescription)
                }
                
            case .failedToLoadData:
                print("** Error: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }
                stopSpinner(activityView: chatViewControllerActivityView)
                
            case .failedToAutostartConversation:
                print("** Error: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }
            case .conversationCreationError:
                print("** Error: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }
            case .failedToSendCustomAttributes:
                print("** Error: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }
                
            case .attachmentDownloadError:
                print("** Error: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }
            default:
                break
            }
        }
    }
    
    func didUpdateState(_ event: ChatStateEvent!) {
        print("Chat event_type: \(event.state)")
        self.chatState = event.state
        
        switch event.state {
        case .chatPreparing:
            print("preparing")
            startSpinner(activityView: wrapperActivityView)
            startSpinner(activityView: chatViewControllerActivityView)
        case .chatStarted:
            print("started")
            stopSpinner(activityView: chatViewControllerActivityView)
        case .chatDisconnected:
            showDisconnectAlert()

        case .unavailable:
            showUnavailableAlert()
        case .chatEnded:
            stopSpinner(activityView: chatViewControllerActivityView)
        default:
            print(event.state)
        }
    }
    
    func showDisconnectAlert() {
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
    }
    
    func showUnavailableAlert() {
        let alert = UIAlertController(title: "Error occurred", message: "Messenger was restricted and can't be processed.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.dismissChat(nil)
        }))
        
        if let topViewController = UIApplication.getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }
    
    func didClickLink(_ url: String) {
        print("Link \(url) was pressed in the chat")
    }
}
