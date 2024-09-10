// ===================================================================================================
// Copyright © 2021 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit
import WebKit

class AuthenticationViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))

        webView.navigationDelegate = self
        view.addSubview(webView)
        
        //The URL logic will be added in a future ticket
        loadAuthenticationURL(url: URL(string: "https://www.okta.com/")!)
    }
    
    private func loadAuthenticationURL(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
