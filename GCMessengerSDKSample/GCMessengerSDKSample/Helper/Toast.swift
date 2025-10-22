// ===================================================================================================
// Copyright © 2021 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================


import Foundation
import UIKit

public class ToastManager {
    static let shared = ToastManager()

    private var activeToastView: UILabel?
    
    public func showToast(message: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        DispatchQueue.main.async {
            // Remove existing toast view if any
            self.activeToastView?.removeFromSuperview()

            let toastView = self.createToastView(message: message, backgroundColor: backgroundColor, textColor: textColor)
            self.activeToastView = toastView

            // Display the new toast
            if let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first {
                
                window.addSubview(toastView)

                let horizontalCenterConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
    
                let widthConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
    
                let height: Int = Int(toastView.layer.cornerRadius * 2)
                let verticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-68-[toastView(==\(height))]-(>=200)-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["toastView": toastView])
    
                NSLayoutConstraint.activate([horizontalCenterConstraint, widthConstraint])
                NSLayoutConstraint.activate(verticalConstraint)
    
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    toastView.alpha = 1
                }, completion: nil)

                // Automatically hide the toast after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UIView.animate(withDuration: 0.5, animations: {
                        toastView.alpha = 0
                    }, completion: { _ in
                        toastView.removeFromSuperview()
                    })
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
