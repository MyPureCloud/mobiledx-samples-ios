// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Combine
import GenesysCloud
import GenesysCloudMessenger

protocol ChatWrapperViewControllerDelegate: AnyObject {
    @MainActor
    func authenticatedSessionError(message: String)
    
    func didLogout()
}

final class ChatWrapperViewController: UIViewController {
    let wrapperActivityView = UIActivityIndicatorView(style: .large)
    let chatViewControllerActivityView = UIActivityIndicatorView(style: .large)

    weak var delegate: ChatWrapperViewControllerDelegate?
    var pushManager: PushActionManager = PushActionManager()
    var chatController: ChatController!
    var messengerAccount = MessengerAccount()
    var chatState: ChatState?
    var isAuthorized = false

    private var cancellables = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<GCError, Never>()

    private var chatControllerNavigationItem: UINavigationItem?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pushManager.removeSnackbar()
    }

    private lazy var menuBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(
                systemName: "line.3.horizontal"
            ),
            style: .plain,
            target: self,
            action: nil
        )
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
        let alert = UIAlertController(
            title: "Clear Conversation",
            message: "Would you like to clear and leave your conversation? Message history will be lost.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(
            UIAlertAction(title: "Yes I'm Sure", style: .destructive) { [weak self] _ in
                guard let self else { return }

                startSpinner(activityView: self.chatViewControllerActivityView)
                chatController.clearConversation()
            })


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

    func showReconnectBarButton() {
        menuBarButtonItem.menu = UIMenu(children: [reconnectAction, endChatAction])

        let alert = UIAlertController(
            title: "Chat was disconnected",
            message: "We were not able to restore chat connection.\nMake sure your device is connected.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        if let topViewController = UIApplication.getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }

    func showUnavailableAlert() {
        let alert = UIAlertController(
            title: "Error occurred",
            message: "Messenger was restricted and can't be processed.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
            self.dismissChat()
        }))

        if let topViewController = UIApplication.getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }

    func dismissChat() {
        chatController.terminate()
        self.presentingViewController?.dismiss(animated: true)
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

extension ChatWrapperViewController: @MainActor ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        if self.chatState == .chatPrepared {
            self.present(viewController, animated: true) { [weak self] in
                guard let self else { return }

                chatControllerNavigationItem = viewController.viewControllers.first?.navigationItem
                
                setDefaultMenuItems()
                chatControllerNavigationItem?.rightBarButtonItem = menuBarButtonItem
                
                setSpinner(activityView: self.chatViewControllerActivityView, view: viewController.viewControllers.first?.view)
                pushManager.checkNotificationAuthStatus()
                
                if chatState == .chatPrepared { //present is async, chatState might changed till we start the spinner
                    startSpinner(activityView: chatViewControllerActivityView)
                    NSLog("ChatWrapperViewController shouldPresentChatViewController startSpinner")
                }
            }
        }
    }
    
    func didUpdateState(_ event: ChatStateEvent) {
        print("Chat event_type: \(event.state)")
        self.chatState = event.state
        
        Task { @MainActor [weak self] in
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
    
    func didClickLink(_ url: String) {
        print("Link \(url) was pressed in the chat")
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: Error handling
extension ChatWrapperViewController {
    private func setupErrorHandling() {
        errorSubject
            .compactMap({ $0 })
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }

    func didFailWithError(_ error: GCError?) {
        guard let error else { return }
        errorSubject.send(error)
    }

    private func handleError(_ error: GCError) {
        error.errorDescription.map { print("Error: \($0)") }

        switch error.errorType {
        case .failedToLoad:
            self.dismissChat()
            error.errorDescription.map { ToastManager.shared.showToast(message: $0) }

        case .failedMessengerChatErrorDisableState:
            error.errorDescription.map { showErrorAlert(message: $0) }

        case .failedToSendMessage:
            print("** CANNOT SEND MESSAGE: \(error.errorType.rawValue)")
            error.errorDescription.map { ToastManager.shared.showToast(message: $0) }

        case .failedToLoadData:
            print("** Error: \(error.errorType.rawValue)")
            stopSpinner(activityView: self.chatViewControllerActivityView)

        case .authLogoutFailed, .clientNotAuthenticatedError:
            error.errorDescription.map { showAuthenticatedSessionErrorAlert(message: $0) }

        case .clearConversationDisabled, .clearConversationFailure:
            error.errorDescription.map { ToastManager.shared.showToast(message: $0) }
            stopSpinner(activityView: chatViewControllerActivityView)

        default:
            error.errorDescription.map { ToastManager.shared.showToast(message: $0) }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error occured", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                self?.dismissChat()
            }
        )
        UIApplication.getTopViewController()?.present(alert, animated: true)
    }

    func showAuthenticatedSessionErrorAlert(message: String) {
        stopSpinner(activityView: wrapperActivityView)
        stopSpinner(activityView: chatViewControllerActivityView)
        delegate?.authenticatedSessionError(message: message)
    }
}
