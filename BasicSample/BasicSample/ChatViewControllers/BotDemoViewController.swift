// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class BotDemoViewController: UIViewController {
    
    var chatController: ChatController!
    var handOver = HandOverHandler()
    
    
    func createAccount() -> Account {
        let account = BotAccount()
        account.account = "{YOUR_ACCOUNT}"
        account.knowledgeBase = "{YOUR_KB}"
        return account
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        chatController = ChatController(account: createAccount())
        chatController.handOver = self.handOver
        chatController.continuityProvider = self
        chatController.speechReconitionDelegate = self
        chatController.delegate = self
    }
    
    @objc func dismissChat(_ sender: UIBarButtonItem?) {
        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension BotDemoViewController: ChatControllerDelegate {
    func shouldPresentChatViewController(_ viewController: UINavigationController!) {
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(viewController, animated: false, completion: nil)
        viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(BotDemoViewController.dismissChat(_:)))
    }
    
    func didUpdateState(_ event: ChatStateEvent!) {
        switch event.state {
        case .preparing:
            print("ChatPreparing")
            break
        case .started:
            print("ChatStarted")
            break
        case .accepted:
            print("ChatAccepted")
            break
        case .ending:
            print("ChatEnding")
            break
        case .ended:
            print("ChatEnded")
            break
        case .unavailable:
            //            let alert = UIAlertController(title: "Chat Unavailable", message: "Please try again later.", preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //            self.navigationController?.presentedViewController?.present(alert, animated: true, completion: {
            //                self.dismissChat(nil)
            //            })
            print("ChatUnavailable")
            break
        case .pending:
            print("ChatPending")
            break
        case .inQueue:
            print("ChatInQueue")
            break
        @unknown default:
            break
        }
    }
}

extension BotDemoViewController: ContinuityProvider{
    func updateContinuityInfo(_ params: [String : String]!) {
        params.forEach { (key, value) in
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    func fetchContinuity(forKey key: String!, handler: ((String?) -> Void)!) {
        handler(UserDefaults.standard.value(forKey: key) as? String)
    }
}

extension BotDemoViewController: SpeechReconitionDelegate {
    func speechRecognitionNotAuthorizedRequset() {
        if let url = URL(string:UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    func speechRecognitionStatus(_ status: NRSpeechRecognizerAuthorizationStatus) {
        
    }
}

extension BotDemoViewController: ApplicationHandler {
    func didClickLink(_ url: String) {
        if #available(iOS 10.0, *) {
            if let link = URL(string: url) {
                 UIApplication.shared.open(link, options: [:], completionHandler: nil)
            }
        } else if let link = URL(string: url) {
           UIApplication.shared.openURL(link)
        }
    }

    func presenting(_ controller: UIViewController, shouldHandleClickedLink link: String) -> Bool {
        return true
    }
    
    func didClick(toCall phoneNumber: String!) {
        let phoneNum = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
        didClickLink("tel://" + phoneNum)
    }
    
    func shouldHandleFormPresentation(_ formController: UIViewController!) -> Bool {
        return false
    }
}


