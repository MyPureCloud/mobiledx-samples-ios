// ===================================================================================================
// Copyright © 2021 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit

@MainActor
public class ToastManager {
    static let shared = ToastManager()

    private init() { }

    private var activeToastView: UILabel?

    public func showToast(message: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        // Remove existing toast if there is any
        activeToastView?.removeFromSuperview()

        let toastView = createToastView(message: message, backgroundColor: backgroundColor, textColor: textColor)
        activeToastView = toastView

        // Display the new toast
        if let topVC = UIApplication.getTopViewController() {
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
                attribute: .width,
                multiplier: 1,
                constant: 275
            )

            let height: Int = Int(toastView.layer.cornerRadius * 2)

            let topConstraint = NSLayoutConstraint(
                item: toastView,
                attribute: .top,
                relatedBy: .equal,
                toItem: topVC.view.safeAreaLayoutGuide,
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
                constant: CGFloat(height)
            )

            NSLayoutConstraint.activate([
                    horizontalCenterConstraint,
                    widthConstraint,
                    topConstraint,
                    heightConstraint
            ])

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                toastView.alpha = 1
            }

            // Automatically hide the toast after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.5) {
                    toastView.alpha = 0
                } completion: { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
    }

    private func createToastView(message: String, backgroundColor: UIColor?, textColor: UIColor?) -> UILabel {
        let toastView = UILabel()
        toastView.accessibilityIdentifier = "toast_view"
        toastView.accessibilityLabel = message
        toastView.backgroundColor = backgroundColor ?? .gray
        toastView.textColor = textColor ?? .black
        toastView.textAlignment = .center
        toastView.font = UIFont.preferredFont(forTextStyle: .caption1)
        toastView.layer.cornerRadius = 15
        toastView.layer.masksToBounds = true
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false

        return toastView
    }
}
