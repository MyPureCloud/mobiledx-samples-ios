//
//  ChatWrapperViewModel.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 04. 28..
//

import Foundation
import GenesysCloud
import UIKit

final class ChatWrapperViewModel: NSObject, @unchecked Sendable {
    @MainActor weak var delegate: ChatWrapperViewModelDelegate?
    @Locked var chatController: ChatController
    @Locked var isTerminated: Bool

    init(account: MessengerAccount) {
        chatController = ChatController(account: account)
        isTerminated = false
        super.init()

        chatController.chatElementDelegate = self // order matters
        chatController.delegate = self
    }

    func endChat(_ forceClose: Bool) {
        chatController.endChat(forceClose)
    }

    func reconnectChat() {
        chatController.reconnectChat()
    }

    func clearConversation() {
        chatController.clearConversation()
    }

    func logoutFromAuthenticatedSession() {
        chatController.logoutFromAuthenticatedSession()
    }

    func terminate() {
        Task { @MainActor [weak self] in
            self?.isTerminated = true
            self?.delegate = nil
            self?.chatController.terminate()
        }
    }

    func updateCustomAttributes(_ customAttributes: [String: String]) {
        chatController.updateCustomAttributes(customAttributes)
    }

    func reauthorizeImplicitFlow(idToken: String, nonce: String) {
        chatController.reauthorizeImplicitFlow(idToken: idToken, nonce: nonce)
    }
}

extension ChatWrapperViewModel: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        guard !isTerminated else { return }

        Task { @MainActor [weak self] in
            self?.delegate?.shouldPresentChatViewController(viewController)
        }
    }

    func didUpdateState(_ event: ChatStateEvent) {
        guard !isTerminated else { return }

        nonisolated(unsafe) let event = event
        Task { @MainActor [weak self] in
            self?.delegate?.didUpdateState(event)
        }
    }

    func didFailWithError(_ error: GCError?) {
        guard !isTerminated else { return }

        Task { @MainActor [weak self] in
            self?.delegate?.didFailWithError(error)
        }
    }

    func didClickLink(_ url: String) {
        guard !isTerminated else { return }

        Task { @MainActor [weak self] in
            self?.delegate?.didClickLink(url)
        }
    }
}

extension ChatWrapperViewModel: ChatElementDelegate {
    func didReceive(chatElement: GenesysCloudCore.ChatElement) {
        guard !isTerminated else { return }

        nonisolated(unsafe) let element = chatElement
        Task { @MainActor [weak self] in
            self?.delegate?.didReceive(chatElement: element)
        }
    }
}
