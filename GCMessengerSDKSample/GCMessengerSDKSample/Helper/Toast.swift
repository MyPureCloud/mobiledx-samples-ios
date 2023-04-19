// ===================================================================================================
// Copyright © 2021 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit

public class Toast {
    public static func show(message: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        DispatchQueue.main.async {
            let toastView = UILabel()
            toastView.backgroundColor = .gray
            toastView.textColor = .black

            if let backgroundColor {
                toastView.backgroundColor = backgroundColor
            }
            if let textColor {
                toastView.textColor = textColor
            }
            toastView.textAlignment = .center
            toastView.font = UIFont.preferredFont(forTextStyle: .caption1)
            toastView.layer.cornerRadius = 15
            toastView.layer.masksToBounds = true
            toastView.text = message
            toastView.numberOfLines = 0
            toastView.alpha = 0
            toastView.translatesAutoresizingMaskIntoConstraints = false

            if let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first {
                window.addSubview(toastView)
                
                let horizontalCenterConstraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: window, attribute: .centerX, multiplier: 1, constant: 0)
                
                let widthConstraint: NSLayoutConstraint = NSLayoutConstraint(item: toastView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 275)
                
                let height: Int = Int(toastView.layer.cornerRadius * 2)
                let verticalConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=200)-[toastView(==\(height))]-68-|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["toastView": toastView])
                
                NSLayoutConstraint.activate([horizontalCenterConstraint, widthConstraint])
                NSLayoutConstraint.activate(verticalConstraint)
                
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {

                    toastView.alpha = 1
                }, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {

                        toastView.alpha = 0
                    }, completion: { finished in
                        toastView.removeFromSuperview()
                    })
                })
            }
        }
    }
}
