// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud
import GenesysCloudMessenger

protocol ChatWrapperViewControllerDelegate: AnyObject {
    @MainActor
    func authenticatedSessionError(message: String)
    
    func didLogout()
}

class ChatWrapperViewController: UIViewController {
    let wrapperActivityView = UIActivityIndicatorView(style: .large)
    let chatViewControllerActivityView = UIActivityIndicatorView(style: .large)

    weak var delegate: ChatWrapperViewControllerDelegate?
    var chatController: ChatController!
    var messengerAccount = MessengerAccount()
    var chatState: ChatState?
    var isAuthorized = false
    
    private var chatControllerNavigationItem: UINavigationItem?
    
    private lazy var menuBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: nil)
        item.tintColor = .black

        return item
    }()
    
    private lazy var endChatAction = UIAction(title: "End Chat", image: nil) { [weak self] _ in
        guard let self else { return }

        dismissChat()
    }
    
    private lazy var logoutAction = UIAction(title: "Logout", image: nil, attributes: UIMenuElement.Attributes.destructive) { [weak self] _ in
        guard let self else { return }

        self.startSpinner(activityView: self.chatViewControllerActivityView)
        self.chatController.logoutFromAuthenticatedSession()
    }
    
    private lazy var reconnectAction: UIAction = UIAction(title: "Reconnect", image: nil) { [weak self] _ in
        guard let self else { return }

        startSpinner(activityView: self.chatViewControllerActivityView)
        chatController.reconnectChat()
    }
    
    private lazy var clearConversationAction = UIAction(title: "Clear Conversation", image: nil) { [weak self] _ in
            let alert = UIAlertController(title: "Clear Conversation", message: "Would you like to clear and leave your conversation? Message history will be lost.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes I'm Sure", style: .destructive, handler: { [weak self] _ in
                guard let self else { return }

                startSpinner(activityView: self.chatViewControllerActivityView)
                chatController.clearConversation()
            }))
            
            
            if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alert, animated: true)
            }
        }
    
    private func setDefaultMenuItems() {
        var menuItems: [UIMenuElement] = []

        if isAuthorized {
            menuItems.append(logoutAction)
        }
        
        menuItems.append(clearConversationAction)
        menuItems.append(endChatAction)
        menuBarButtonItem.menu = UIMenu(children: menuItems)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatController = ChatController(account: messengerAccount)
        chatController.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSpinner(activityView: wrapperActivityView, view: view)
    }

    func dismissChat() {
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

                chatControllerNavigationItem = viewController.viewControllers.first?.navigationItem
                
                setDefaultMenuItems()
                chatControllerNavigationItem?.rightBarButtonItem = menuBarButtonItem
                
                setSpinner(activityView: self.chatViewControllerActivityView, view: viewController.viewControllers.first?.view)
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
                dismissChat()
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: "\(errorDescription)")
                }
            case .failedMessengerChatErrorDisableState:
                if let errorDescription = error.errorDescription {
                    let alert = UIAlertController(title: "Error occurred", message: errorDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                        self?.dismissChat()
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
                
                if let errorDescription = error.errorDescription {
                    showAuthenticatedSessionErrorAlert(message: errorDescription)
                }
                
            case .clearConversationDisabled, .clearConversationFailure:
                print("** Error: \(error.errorType.rawValue)")
                
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }
                stopSpinner(activityView: chatViewControllerActivityView)
            case .chatGeneralError:
                print("** Error: \(error.errorType.rawValue)")
                
                if let errorDescription = error.errorDescription {
                    showAuthenticatedSessionErrorAlert(message: errorDescription)
                }
                
            case .attachmentValidationError:
                print("** Error: \(error.errorType.rawValue)")
                if let errorDescription = error.errorDescription {
                    ToastManager.shared.showToast(message: errorDescription)
                }

            default:
                break
            }
        }
    }
    
    func didUpdateState(_ event: ChatStateEvent) {
        print("Chat event_type: \(event.state)")
        self.chatState = event.state
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            switch event.state {
            case .chatPreparing:
                print("preparing")
                startSpinner(activityView: wrapperActivityView)
                startSpinner(activityView: chatViewControllerActivityView)
            case .chatStarted:
                print("started")
                
                setDefaultMenuItems()
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
                    case EndedReason.conversationCleared:
                        ToastManager.shared.showToast(message: "Conversation was cleared.")
                        return
                    case EndedReason.logout:
                        delegate?.didLogout()
                    default:
                        break
                    }
                    presentingViewController?.dismiss(animated: true)
                }
                
            default:
                print(event.state)
            }
        }
    }

    func showReconnectBarButton() {
        menuBarButtonItem.menu = UIMenu(children: [reconnectAction, endChatAction])
        
        let alert = UIAlertController(title: "Chat was disconnected", message: "We were not able to restore chat connection.\nMake sure your device is connected.", preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let topViewController = UIApplication.getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }
    
    func showAuthenticatedSessionErrorAlert(message: String) {
        delegate?.authenticatedSessionError(message: message)
    }
    
    func showUnavailableAlert() {
        let alert = UIAlertController(title: "Error occurred", message: "Messenger was restricted and can't be processed.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.dismissChat()
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
