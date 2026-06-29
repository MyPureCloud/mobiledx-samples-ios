//
//  ChatWrapperViewModelDelegate.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 04. 28..
//

import Foundation
import GenesysCloud
import UIKit

@MainActor
protocol ChatWrapperViewModelDelegate: AnyObject {
    func shouldPresentChatViewController(_ viewController: UINavigationController!)
    func didUpdateState(_ event: ChatStateEvent)
    func didFailWithError(_ error: GCError?)
    func didReceive(chatElement: ChatElement)
    func didClickLink(_ url: String)
}
