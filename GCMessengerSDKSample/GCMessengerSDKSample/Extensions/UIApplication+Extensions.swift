// ===================================================================================================
// Copyright © 2022 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }

    class func safelyDismissTopViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.getTopViewController() else {
                completion?()
                return
            }

            let hasPresented = topVC.presentedViewController != nil || topVC.presentingViewController != nil

            if let presented = topVC.presentedViewController {
                presented.dismiss(animated: animated, completion: {
                    completion?()
                })
            } else if let presenting = topVC.presentingViewController {
                topVC.dismiss(animated: animated, completion: {
                    completion?()
                })
            } else {
                completion?()
            }
        }
    }
}
