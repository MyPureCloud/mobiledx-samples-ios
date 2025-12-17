// ===================================================================================================
// Copyright © 2021 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import UIKit
@preconcurrency import WebKit

@MainActor
protocol AuthenticationViewControllerDelegate: AnyObject {
    func didGetAuthInfo(authCode: String, redirectUri: String, codeVerifier: String?)
    func didGetImplicitAuthInfo(idToken: String, nonce: String, isReauthorization: Bool)
    func error(message: String)
}

@MainActor
class AuthenticationViewController: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    
    private var authCode: String?
    private var codeVerifier: String?
    private var signInRedirectURI: String?
    private var nonce: String?
    var isImplicitFlow: Bool = false
    var isImplicitFlowReauthorization: Bool = false

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

        let responseType = isImplicitFlow ? "id_token" : "code"

        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "response_type", value: responseType),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: signInRedirectURI),
            URLQueryItem(name: "state", value: oktaState),
            URLQueryItem(name: "code_challenge_method", value: codeChallengeMethod),
            URLQueryItem(name: "code_challenge", value: codeChallenge)
        ]

        if isImplicitFlow {
            nonce = UUID().uuidString
            urlComponents?.queryItems?.append(URLQueryItem(name: "nonce", value: nonce))
        }

        guard let url = urlComponents?.url else {
            return nil
        }
        
        self.signInRedirectURI = signInRedirectURI
        self.codeVerifier = codeVerifier
        
        return URL(string: url.absoluteString)
    }

    private func handleImplicitFlowReturnURL(_ url: URL) {
        guard let nonce, let fragment = url.fragment else { return }

        var components = URLComponents()
        components.query = fragment
        let params = Dictionary(
            uniqueKeysWithValues: (components.queryItems ?? []).compactMap { item -> (String, String)? in
                guard let value = item.value else { return nil }
                return (item.name, value)
            })

        guard let idToken = params["id_token"] else {
               if let error = params["error"] {
                     print("Error during implicit flow login \(error)")
               }
               return
        }

        delegate?.didGetImplicitAuthInfo(idToken: idToken, nonce: nonce, isReauthorization: isImplicitFlowReauthorization)
    }

    private func handleAuthCodeFlowReturnURL(_ url: URL) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }

        if let signInRedirectURI,
           let code = urlComponents.queryItems?.first(where: { $0.name == "code" })?.value {
            delegate?.didGetAuthInfo(authCode: code, redirectUri: signInRedirectURI, codeVerifier: codeVerifier)
        }
    }

    internal func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (((WKNavigationActionPolicy) -> Void))) {
        defer { decisionHandler(.allow) }
        guard let url = navigationAction.request.url else { return }

        if isImplicitFlow {
            handleImplicitFlowReturnURL(url)
        } else {
            handleAuthCodeFlowReturnURL(url)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let javascript = """
            try {
                    var inputFields = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
                    for (var i = 0; i < inputFields.length; i++) {
                        inputFields[i].value = '';
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
