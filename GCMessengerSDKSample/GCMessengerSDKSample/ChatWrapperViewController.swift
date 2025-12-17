// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud
import GenesysCloudMessenger

@objc public enum ChatElementKind: Int {
    case agent
    case system
    case user
}

@objc public class ChatElement: NSObject {
    @objc public var id: String
    @objc public var isLoadedFromHistory: Bool
    @objc public var timestamp: Date
    @objc public var kind: ChatElementKind
    @objc dynamic public var userState: UserChatElementState = .none

    init(chatElement: GenesysCloudCore.ChatElement) {
        id = chatElement.id
        isLoadedFromHistory = chatElement.isLoadedFromHistory
        timestamp = chatElement.timestamp
        switch chatElement.kind {
        case .agent:
            kind = .agent
        case .system:
            kind = .system
        case .user(state: let state):
            kind = .user
            userState = state
    }
}

protocol ChatWrapperViewControllerDelegate: AnyObject {
    @MainActor
    func didReceive(chatElement: ChatElement)
    func authenticatedSessionError(message: String)
    func didLogout()
    func minimize()
    func dismiss()
    func reauthorizationRequired()
}

class ChatWrapperViewController: UIViewController {
    let wrapperActivityView = UIActivityIndicatorView(style: .large)
    let chatViewControllerActivityView = UIActivityIndicatorView(style: .large)

    weak var delegate: ChatWrapperViewControllerDelegate?
    var chatController: ChatController!
    var chatViewController: UIViewController?
    var messengerAccount = MessengerAccount()
    var chatState: ChatState?
    var isAuthorized = false
    var isRegisteredToPushNotifications = false
    var isAlertCurrentlyPresented = false
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(alert: alert)
        }))
        alert.addAction(UIAlertAction(title: "Yes I'm Sure", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }
            
            startSpinner(activityView: self.chatViewControllerActivityView)
            chatController.clearConversation()
            dismiss(alert: alert)
        }))
        
        self?.present(alert: alert)
    }
    
    private lazy var minimizeChatAction = UIAction(title: "Minimize Chat", image: nil) { [weak self] _ in
        self?.delegate?.minimize()
    }
    
    private func setDefaultMenuItems() {
        var menuItems: [UIMenuElement] = []

        if isAuthorized {
            menuItems.append(logoutAction)
        }
        
        menuItems.append(clearConversationAction)
        menuItems.append(minimizeChatAction)
        menuItems.append(endChatAction)
        menuBarButtonItem.menu = UIMenu(children: menuItems)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatController = ChatController(account: messengerAccount)
        chatController.chatElementDelegate = self //Order matters
        chatController.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setSpinner(activityView: wrapperActivityView, view: view)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSnackbar()
    }

    func dismissChat() {
        chatController.terminate()
        chatViewController = nil
        delegate?.dismiss()
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

extension ChatWrapperViewController: ChatControllerDelegate, ChatElementDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        chatViewController = viewController
        if self.chatState == .chatPrepared {
            self.present(viewController, animated: true) { [weak self] in
                guard let self else { return }

                chatControllerNavigationItem = viewController.viewControllers.first?.navigationItem
                
                setDefaultMenuItems()
                chatControllerNavigationItem?.rightBarButtonItem = menuBarButtonItem
                
                setSpinner(activityView: self.chatViewControllerActivityView, view: viewController.viewControllers.first?.view)
                checkNotificationAuthStatus()
                
                if chatState == .chatPrepared { //present is async, chatState might changed till we start the spinner
                    startSpinner(activityView: chatViewControllerActivityView)
                    NSLog("ChatWrapperViewController shouldPresentChatViewController startSpinner")
                }
            }
        }
    }
    
    func checkNotificationAuthStatus() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { [weak self] permission in
            guard let self else { return }
            
            if permission.authorizationStatus != .authorized {
                self.showPushSnackbar()
            }
        })
    }
    
    func showPushSnackbar() {
        if !isRegisteredToPushNotifications {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            SnackbarView.shared.show(
                topAnchorView: self.view,
                message: "Notifications are disabled",
                title: "Settings",
                onButtonTap: self.openAppSettings,
                onCloseTap: self.removeSnackbar)
        }
    }
    
    func removeSnackbar() { SnackbarView.shared.remove() }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
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

            case .authorizationRequired:
                print("** Error: \(String(describing: error.errorDescription))")
                delegate?.reauthorizationRequired()
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
            case .chatStarted:
                print("started")
                
                setDefaultMenuItems()
                stopSpinner(activityView: chatViewControllerActivityView)
            case .chatDisconnected:
                handleChatDisconnectedState()
                
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
    
    private func present(alert: UIAlertController) {
        guard !isAlertCurrentlyPresented else {
            NSLog("Won't present alert as another one is already presented")
            return
        }
        
        if let topViewController = UIApplication.getTopViewController() {
                topViewController.present(alert, animated: true)
                isAlertCurrentlyPresented = true
        }
    }
    
    private func dismiss(alert: UIAlertController) {
        isAlertCurrentlyPresented = false
        alert.dismiss(animated: true)
    }

    private func handleChatDisconnectedState() {
        menuBarButtonItem.menu = UIMenu(children: [reconnectAction, endChatAction])
        
        let alert = UIAlertController(title: "Chat was disconnected", message: "We were not able to restore chat connection.\nMake sure your device is connected.", preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(alert: alert)
        }))
        present(alert: alert)
    }
    
    private func showAuthenticatedSessionErrorAlert(message: String) {
        stopSpinner(activityView: wrapperActivityView)
        stopSpinner(activityView: chatViewControllerActivityView)
        delegate?.authenticatedSessionError(message: message)
    }
    
    private func showUnavailableAlert() {
        let alert = UIAlertController(title: "Error occurred", message: "Messenger was restricted and can't be processed.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(alert: alert)
        }))
        
        present(alert: alert)
    }
    
    func didClickLink(_ url: String) {
        NSLog("Link \(url) was pressed in the chat")
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    func didReceive(chatElement: ChatElement) {
        NSLog("New meassage arrived: \(String(describing: chatElement.getText()))")
        
        if !(chatElement is TypingIndicatorChatElement) && chatElement.kind == .agent {
            delegate?.didReceive(chatElement: chatElement)
        }
    }
}
