// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import GenesysCloud
import GenesysCloudMessenger

@MainActor
protocol ChatWrapperViewControllerDelegate: AnyObject {
    func didReceive(chatElement: ChatElement)
    func authenticatedSessionError(message: String)
    func didLogout()
    func didUnregisterPushNotifications()
    func minimize()
    func dismiss()
    func reauthorizationRequired()
}

class ChatWrapperViewController: UIViewController {
    weak var delegate: ChatWrapperViewControllerDelegate?
    var viewModel: ChatWrapperViewModel!
    var chatViewController: UIViewController?
    var messengerAccount = MessengerAccount()
    var chatState: ChatState?
    var isAuthorized = false
    var isRegisteredToPushNotifications = false
    var isAlertCurrentlyPresented = false
    private var chatControllerNavigationItem: UINavigationItem?
    private let wrapperSpinnerPresenter = SpinnerPresenter()
    private let chatVCSpinnerPresenter = SpinnerPresenter()
    private let errorHandler = ChatErrorHandler()
    private let toastPresenter = ToastPresenter()

    private lazy var menuBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: nil)
        item.tintColor = .black

        return item
    }()

    private lazy var endChatAction = UIAction(title: "End Chat", image: nil) { [weak self] _ in
        guard let self else { return }
        dismissChat()
    }

    private lazy var logoutAction = UIAction(
        title: "Logout",
        image: nil,
        attributes: UIMenuElement.Attributes.destructive
    ) { [weak self] _ in
        guard let self else { return }

        chatVCSpinnerPresenter.start()
        self.unregisterPushAndLogout()
    }

    private lazy var reconnectAction: UIAction = UIAction(title: "Reconnect", image: nil) { [weak self] _ in
        guard let self else { return }

        chatVCSpinnerPresenter.start()
        viewModel.reconnectChat()
    }

    private lazy var clearConversationAction = UIAction(title: "Clear Conversation", image: nil) { [weak self] _ in
        let alert = UIAlertController(
            title: "Clear Conversation",
            message: "Would you like to clear and leave your conversation? Message history will be lost.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(alert: alert)
        }))
        alert.addAction(UIAlertAction(title: "Yes I'm Sure", style: .destructive, handler: { [weak self] _ in
            guard let self else { return }

            chatVCSpinnerPresenter.start()
            viewModel.clearConversation()
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
        viewModel = ChatWrapperViewModel(account: messengerAccount)
        viewModel.delegate = self
        errorHandler.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wrapperSpinnerPresenter.attach(to: view)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSnackbar()
    }

    /// Unregisters from push notifications (if registered) before calling logout API to prevent receiving notifications after logout.
    private func unregisterPushAndLogout() {
        guard isRegisteredToPushNotifications else {
            viewModel.logoutFromAuthenticatedSession()
            return
        }

        ChatPushNotificationIntegration.removePushToken(account: messengerAccount) { [weak self] result in
            guard let self else { return }

            defer { viewModel.logoutFromAuthenticatedSession() }

            switch result {
            case .success:
                Logger.info("Push notifications unregistered before logout")
                isRegisteredToPushNotifications = false
                delegate?.didUnregisterPushNotifications()
            case .failure(let error):
                Logger.error("Failed to unregister push before logout: \(error.errorDescription ?? "unknown error"). Proceeding with logout.")
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
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

        Task { @MainActor in
            await SnackbarView.shared.show(
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

    private func present(alert: UIAlertController) {
        guard !isAlertCurrentlyPresented else {
            Logger.warning("Alert already presented, skipping")
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

        let alert = UIAlertController(
            title: "Chat was disconnected",
            message: "We were not able to restore chat connection.\nMake sure your device is connected.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.dismiss(alert: alert)
        }))
        present(alert: alert)
    }

    private func showAuthenticatedSessionErrorAlert(message: String) {
        wrapperSpinnerPresenter.stop()

        UIApplication.safelyDismissTopViewController(animated: true, completion: { [weak self] in
            guard let self else { return }

            delegate?.authenticatedSessionError(message: message)
        })
    }

    private func showUnavailableAlert() {
        let alert = UIAlertController(
            title: "Error occurred",
            message: "Messenger was restricted and can't be processed.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(alert: alert)
        }))

        present(alert: alert)
    }
}

extension ChatWrapperViewController: ChatWrapperViewModelDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .overFullScreen
        chatViewController = viewController
        if self.chatState == .chatPrepared {
            self.present(viewController, animated: true) { [weak self] in
                guard let self else { return }

                chatControllerNavigationItem = viewController.viewControllers.first?.navigationItem

                setDefaultMenuItems()
                chatControllerNavigationItem?.rightBarButtonItem = menuBarButtonItem

                guard let view = viewController.viewControllers.first?.view else { return }
                chatVCSpinnerPresenter.attach(to: view)
                checkNotificationAuthStatus()

                if chatState == .chatPrepared { // present is async, chatState might changed till we start the spinner
                    chatVCSpinnerPresenter.start()
                    Logger.info("Chat view controller spinner started")
                }
            }
        }
    }

    func didFailWithError(_ error: GCError?) {
        guard let error else { return }

        Task { @MainActor in
            await errorHandler.handle(error)
        }
    }

    func didUpdateState(_ event: ChatStateEvent) {
        Logger.info("Chat state: \(event.state)")
        self.chatState = event.state

        Task { @MainActor [weak self] in
            guard let self else { return }

            switch event.state {
            case .chatPreparing:
                Logger.info("Chat preparing")
                wrapperSpinnerPresenter.start()
            case .chatStarted:
                Logger.info("Chat started")

                setDefaultMenuItems()
                chatVCSpinnerPresenter.stop()
            case .chatDisconnected:
                handleChatDisconnectedState()

            case .unavailable:
                showUnavailableAlert()
            case .chatEnded:
                chatVCSpinnerPresenter.stop()
            case .chatClosed:
                let endedReasonRawValue = event.dataMsg as? Int ?? 0
                if let endedReason = EndedReason(rawValue: endedReasonRawValue) {
                    switch endedReason {
                    case EndedReason.sessionLimitReached:
                        await self.toastPresenter.present(
                            ToastView(message: "You have been logged out because the session limit was exceeded.")
                        )
                    case EndedReason.conversationCleared:
                        await self.toastPresenter.present(
                            ToastView(message: "Conversation was cleared.")
                        )
                        return
                    case EndedReason.logout:
                        delegate?.didLogout()
                    case EndedReason.sessionExpired:
                        await self.toastPresenter.present(
                            ToastView(message: "Session has expired")
                        )
                    default:
                        break
                    }
                    presentingViewController?.dismiss(animated: true)
                }

            default:
                Logger.info("Chat state: \(event.state)")
            }
        }
    }

    func didClickLink(_ url: String) {
        Logger.info("Link clicked: \(url)")
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }

    func didReceive(chatElement: ChatElement) {
        Logger.info("Message received: \(chatElement.getText() ?? "")")

        if !(chatElement is TypingIndicatorChatElement) && chatElement.kind == .agent {
            delegate?.didReceive(chatElement: chatElement)
        }
    }
}

extension ChatWrapperViewController: ChatErrorHandlerDelegate {
    func presentAlert(title: String, message: String, onConfirm: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let onConfirm {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                onConfirm()
            }))
        }

        if let topViewController = UIApplication.getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }

    func dismissChat() {
        viewModel.terminate()
        chatViewController = nil
        delegate?.dismiss()
    }

    func reauthorizationRequired() {
        delegate?.reauthorizationRequired()
    }

    func authenticatedSessionError(message: String) {
        showAuthenticatedSessionErrorAlert(message: message)
    }

    func chatDisconnected() {
        handleChatDisconnectedState()
    }

    func stopSpinner() {
        chatVCSpinnerPresenter.stop()
    }
}
