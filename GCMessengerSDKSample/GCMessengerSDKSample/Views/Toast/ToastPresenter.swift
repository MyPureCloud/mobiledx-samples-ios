//
//  ToastPresenter.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 03..
//

import Foundation
import UIKit

@MainActor
final class ToastPresenter {
    func present(_ toastView: ToastView) async {
        guard let topVC = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .compactMap({$0 as? UIWindowScene})
                        .first?.windows
                        .filter({$0.isKeyWindow})
                        .first?.rootViewController else { return }

        topVC.view.addSubview(toastView)

        let horizontalCenterConstraint = NSLayoutConstraint(
            item: toastView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: topVC.view,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )

        let widthConstraint = NSLayoutConstraint(
            item: toastView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 275
        )

        let topConstraint = NSLayoutConstraint(
            item: toastView,
            attribute: .top,
            relatedBy: .equal,
            toItem: topVC.view,
            attribute: .top,
            multiplier: 1,
            constant: 68
        )

        let heightConstraint = NSLayoutConstraint(
            item: toastView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: toastView.layer.cornerRadius * 2
        )

        NSLayoutConstraint.activate([
            horizontalCenterConstraint,
            widthConstraint,
            heightConstraint,
            topConstraint
        ])

        UIView.animate(withDuration: 0.5, delay: 0) {
            toastView.alpha = 1
        }

        try? await Task.sleep(nanoseconds: 2_000_000_000)

        dismiss(toastView)
    }

    func dismiss(_ toastView: ToastView) {
        UIView.animate(withDuration: 0.5) {
            toastView.alpha = 0
        } completion: { _ in
            toastView.removeFromSuperview()
        }
    }
}
