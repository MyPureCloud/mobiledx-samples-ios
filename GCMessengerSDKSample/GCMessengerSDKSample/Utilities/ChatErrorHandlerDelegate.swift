//
//  ChatErrorHandlerDelegate.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 30..
//

import Foundation

@MainActor
protocol ChatErrorHandlerDelegate: AnyObject {
    func presentAlert(title: String, message: String, onConfirm: (() -> Void)?)
    func dismissChat()
    func reauthorizationRequired()
    func authenticatedSessionError(message: String)
    func chatDisconnected()
    func stopSpinner()
}
