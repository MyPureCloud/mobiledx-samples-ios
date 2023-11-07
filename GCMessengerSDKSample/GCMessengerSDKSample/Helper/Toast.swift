// ===================================================================================================
// Copyright © 2021 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit

public class Toast {
    static var toastQueue: [String] = []
    static var isToastBeingDisplayed = false
    
    public static func show(message: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        DispatchQueue.main.async {
            toastQueue.append(message)
            processQueue(backgroundColor: backgroundColor, textColor: textColor)
        }
    }
    
    private static func processQueue(backgroundColor: UIColor?, textColor: UIColor?) {
        guard !isToastBeingDisplayed, let message = toastQueue.first else { return }
        
        isToastBeingDisplayed = true
        
        let toastView = createToastView(message: message, backgroundColor: backgroundColor, textColor: textColor)
        
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    toastView.alpha = 0
                }, completion: { finished in
                    toastView.removeFromSuperview()
                    toastQueue.removeFirst()
                    isToastBeingDisplayed = false
                    processQueue(backgroundColor: backgroundColor, textColor: textColor)
                })
            }
        }
    }
    
    private static func createToastView(message: String, backgroundColor: UIColor?, textColor: UIColor?) -> UILabel {
        let toastView = UILabel()
        
        toastView.backgroundColor = .gray
        toastView.textColor = .black
        
        if let backgroundColor = backgroundColor {
            toastView.backgroundColor = backgroundColor
        }
        if let textColor = textColor {
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
        
        return toastView
    }
}
