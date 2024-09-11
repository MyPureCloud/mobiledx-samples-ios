// ===================================================================================================
// Copyright © 2021 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit
import WebKit

protocol AuthenticationViewControllerDelegate: AnyObject {
    func authenticationSucceeded(authCode: String, redirectUri: String, codeVerifier: String?)
    func error(message: String)
}

class AuthenticationViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    
    private var authCode: String?
    private var codeVerifier: String?
    private var signInRedirectURI: String?
    
    weak var delegate: AuthenticationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height))
        webView.allowsBackForwardNavigationGestures = true

        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let oktaAuthorizeUrl = buildOktaAuthorizeUrl() else {
            delegate?.authenticationSucceeded(authCode: "code", redirectUri: "signInRedirectURI", codeVerifier: "self.codeVerifier")

            return
        }
        
        loadAuthenticationURL(url: oktaAuthorizeUrl)
    }
    
    private func loadAuthenticationURL(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            webView.load(URLRequest(url: url))
        }
    }
    
    private func buildOktaAuthorizeUrl() -> URL? {
        guard let plistPath = Bundle.main.path(forResource: "Okta", ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: plistPath),
              let plistDictionary = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any],
              let oktaDomain = plistDictionary["oktaDomain"] as? String,
              let clientId = plistDictionary["clientId"] as? String,
              let signInRedirectURI = plistDictionary["signInRedirectURI"] as? String,
              let scope = plistDictionary["scopes"] as? String,
              let oktaState = plistDictionary["oktaState"] as? String,
              let codeChallengeMethod = plistDictionary["codeChallengeMethod"] as? String,
              let codeChallenge = plistDictionary["codeChallenge"] as? String,
              let codeVerifier = plistDictionary["codeVerifier"] as? String
        else {
            return nil
        }
        
        self.signInRedirectURI = signInRedirectURI
        self.codeVerifier = codeVerifier
        
        var urlComponents = URLComponents(string: "https://\(oktaDomain)/oauth2/default/v1/authorize")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: signInRedirectURI),
            URLQueryItem(name: "state", value: oktaState),
            URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod),
            URLQueryItem(name: "code_challenge", value: codeChallenge)
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        return URL(string: url.absoluteString)
    }
    
    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (((WKNavigationActionPolicy) -> Void))) {
        if let url = navigationAction.request.url {
            if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                if let queryItems = urlComponents.queryItems {
                    for item in queryItems {
                        if item.name == "code", let code = item.value {
                            if let signInRedirectURI {
                                delegate?.authenticationSucceeded(authCode: code, redirectUri: signInRedirectURI, codeVerifier: self.codeVerifier)
                            }
                        }
                        break
                    }
                }
                
                decisionHandler(.allow)
            }
        }
    }
}
