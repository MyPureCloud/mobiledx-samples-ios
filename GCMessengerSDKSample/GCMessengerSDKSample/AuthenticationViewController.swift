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

        webView.navigationDelegate = self
        view.addSubview(webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let oktaAuthorizeUrl = buildOktaAuthorizeUrl() else {
            delegate?.error(message: "Please make sure you added Okta.plist file with proper values")

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
              let oktaDomain = plistDictionary["oktaDomain"] as? String, !oktaDomain.isEmpty,
              let clientId = plistDictionary["clientId"] as? String, !clientId.isEmpty,
              let signInRedirectURI = plistDictionary["signInRedirectURI"] as? String, !signInRedirectURI.isEmpty,
              let scope = plistDictionary["scopes"] as? String, !scope.isEmpty,
              let oktaState = plistDictionary["oktaState"] as? String, !oktaState.isEmpty,
              let codeChallengeMethod = plistDictionary["codeChallengeMethod"] as? String, !codeChallengeMethod.isEmpty,
              let codeChallenge = plistDictionary["codeChallenge"] as? String, !codeChallenge.isEmpty,
              let codeVerifier = plistDictionary["codeVerifier"] as? String, !codeVerifier.isEmpty
        else {
            return nil
        }
        
        var urlComponents = URLComponents(string: "https://\(oktaDomain)/oauth2/default/v1/authorize")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: signInRedirectURI),
            URLQueryItem(name: "state", value: oktaState),
            URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod),
            URLQueryItem(name: "code_challenge", value: codeChallenge)
        ]
        
        guard let url = urlComponents?.url else {
            return nil
        }
        
        self.signInRedirectURI = signInRedirectURI
        self.codeVerifier = codeVerifier
        
        return URL(string: url.absoluteString)
    }
    
    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (((WKNavigationActionPolicy) -> Void))) {
        guard let url = navigationAction.request.url,
              let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }

        if let signInRedirectURI,
           let code = urlComponents.queryItems?.first(where: { $0.name == "code" })?.value {
            delegate?.authenticationSucceeded(authCode: code, redirectUri: signInRedirectURI, codeVerifier: codeVerifier)
        }

        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript = """
            try {
                    var inputFields = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
                    if (inputFields.length > 0) {
                        for (var i = 0; i < inputFields.length; i++) {
                            inputFields[i].value = '';
                        }
                    }
                } catch (e) {
                    // If an error occurs, return the error's message.
                    e.message;
                }
        """
        
        // Execute the JavaScript
        webView.evaluateJavaScript(javascript) { (result, error) in
            if let error = error {
                print("JavaScript evaluation failed: \(error.localizedDescription)")
            } else {
                print("Successfully disabled autocomplete on text fields.")
            }
        }
    }
}
