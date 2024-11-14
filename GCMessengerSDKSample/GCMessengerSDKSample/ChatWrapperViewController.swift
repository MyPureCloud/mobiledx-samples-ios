// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud
import GenesysCloudMessenger

protocol ChatWrapperViewControllerDelegate: AnyObject {
    func authenticatedSessionError(message: String)
}

class ChatWrapperViewController: UIViewController {
    let wrapperActivityView = UIActivityIndicatorView(style: .large)
    let chatViewControllerActivityView = UIActivityIndicatorView(style: .large)

    weak var delegate: ChatWrapperViewControllerDelegate?
    var chatController: ChatController!
    var messengerAccount = MessengerAccount()
    var chatState: ChatState?
    
    private var rightBarButtonItem: UIBarButtonItem?
    private var chatControllerNavigationItem: UINavigationItem?

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
            self.present(viewController, animated: true) { [weak self] in
                guard let self else { return }

                viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "End Chat", style: .plain, target: self, action: #selector(ChatWrapperViewController.dismissChat(_:)))
                
                self.chatControllerNavigationItem = viewController.viewControllers.first?.navigationItem

                if let _ = self.messengerAccount.authenticationInfo {
                    self.setLogoutButton()
                } else {
                    self.chatControllerNavigationItem?.rightBarButtonItem = nil
                }
                
                self.setSpinner(activityView: self.chatViewControllerActivityView, view: viewController.viewControllers.first?.view)
            }
        }
    }
    
    private func setLogoutButton() {
        rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(ChatWrapperViewController.logout(_:)))
        rightBarButtonItem?.tintColor = .black
        self.chatControllerNavigationItem?.rightBarButtonItem = rightBarButtonItem
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
                
            case .authLogoutFailed:
                print("** Error: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    showAuthenticatedSessionErrorAlert(message: errorDescription)
                }
            case .clientNotAuthenticatedError:
                print("** Error: \(error.errorType.rawValue)")
                dismissChat(nil)
                
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }
                
            case .chatGeneralError:
                print("** Error: \(error.errorType.rawValue)")
                dismissChat(nil)
                
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
            DispatchQueue.main.async { [weak self] in
                if self?.messengerAccount.authenticationInfo == nil {
                    self?.chatControllerNavigationItem?.rightBarButtonItem = nil
                } else {
                    self?.setLogoutButton()
                }
            }
            stopSpinner(activityView: chatViewControllerActivityView)
        case .chatDisconnected:
            showReconnectBarButton()

        case .unavailable:
            showUnavailableAlert()
        case .chatEnded:
            stopSpinner(activityView: chatViewControllerActivityView)
        case .chatClosed:
            let endedReasonRawValue = event.dataMsg as? Int ?? 0
            if let endedReason = EndedReason(rawValue: endedReasonRawValue) {
                switch endedReason {
                case EndedReason.sessionLimitReached:
                    ToastManager.shared.showToast(message: "You have been logged out because the session limit was exceeded.")
                case EndedReason.logout:
                    presentingViewController?.dismiss(animated: true)
                default:
                    break
                }
            }
        default:
            print(event.state)
        }
    }

    func showReconnectBarButton() {
        rightBarButtonItem = UIBarButtonItem(title: "Reconnect", style: .plain, target: self, action: #selector(ChatWrapperViewController.reconnectChat))
        rightBarButtonItem?.tintColor = .red
        self.chatControllerNavigationItem?.rightBarButtonItem = rightBarButtonItem
        
        let alert = UIAlertController(title: "Chat was disconnected", message: "We were not able to restore chat connection.\nMake sure your device is connected.", preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
        }))
        
        if let topViewController = UIApplication.getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }
    
    func showAuthenticatedSessionErrorAlert(message: String) {
        delegate?.authenticatedSessionError(message: message)
    }
    
    func reconnectChat() {
        self.chatController.reconnectChat()
    }
    
    @objc func logout(_ sender: UIBarButtonItem?) {
        chatController.logoutFromAuthenticatedSession()
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
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
