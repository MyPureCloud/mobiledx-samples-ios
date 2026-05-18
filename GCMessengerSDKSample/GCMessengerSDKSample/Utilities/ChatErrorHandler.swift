//
//  ChatErrorHandler.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 30..
//

import Foundation
import GenesysCloud

@MainActor
final class ChatErrorHandler {
    weak var delegate: ChatErrorHandlerDelegate?
    private let toastPresenter = ToastPresenter()

    func handle(_ error: GCError) async {
        if let errorDescription = error.errorDescription {
            Logger.error("Chat error: \(errorDescription)")
        }

        switch error.errorType {
        case .failedToLoad:
            delegate?.dismissChat()
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }
        case .failedMessengerChatErrorDisableState:
            if let errorDescription = error.errorDescription {
                delegate?.presentAlert(title: "Error occurred", message: errorDescription, onConfirm: delegate?.dismissChat)
            }
        case .failedToSendMessage:
            Logger.error("Failed to send message: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }

        case .failedToLoadData:
            Logger.error("Failed to load data: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }
            delegate?.stopSpinner()

        case .failedToAutostartConversation:
            Logger.error("Autostart failed: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }
        case .conversationCreationError:
            Logger.error("Conversation creation failed: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }
        case .failedToSendCustomAttributes:
            Logger.error("Custom attributes send failed: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }

        case .attachmentDownloadError:
            Logger.error("Attachment download failed: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }

        case .authLogoutFailed:
            Logger.error("Auth logout failed: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                delegate?.authenticatedSessionError(message: errorDescription)
            }
        case .clientNotAuthenticatedError:
            Logger.error("Client not authenticated: \(error.errorType.rawValue)")

            if let errorDescription = error.errorDescription {
                delegate?.authenticatedSessionError(message: errorDescription)
            }

        case .clearConversationDisabled, .clearConversationFailure:
            Logger.error("Clear conversation failed: \(error.errorType.rawValue)")

            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }
            delegate?.stopSpinner()
        case .chatGeneralError:
            Logger.error("Chat general error: \(error.errorType.rawValue)")

            if let errorDescription = error.errorDescription {
                delegate?.authenticatedSessionError(message: errorDescription)
            }

        case .attachmentValidationError:
            Logger.error("Attachment validation failed: \(error.errorType.rawValue)")
            if let errorDescription = error.errorDescription {
                await toastPresenter.present(ToastView(message: errorDescription))
            }

        case .authorizationRequired:
            Logger.error("** Error: \(String(describing: error.errorDescription))")
            delegate?.reauthorizationRequired()

        case .failedToReconnect:
            delegate?.chatDisconnected()

        default:
            break
        }
    }
}
