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
    var account: Account!
    var chatConfiguration: Bold360AI.ChatConfiguration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatController.clearCache(withInvalidDays:0)
        // Do any additional setup after loading the view.
        chatController = ChatController(account: account)
        chatController.handOver = self.handOver
        chatController.continuityProvider = self
        chatController.speechReconitionDelegate = self
        chatController.delegate = self
        
        chatController.viewConfiguration.voiceToVoiceConfiguration.type = .default
        if let config = self.chatConfiguration {
            chatController.viewConfiguration = config
        }
        
    }
    
    @objc func dismissChat(_ sender: UIBarButtonItem?) {
        self.navigationController?.presentedViewController?.dismiss(animated: false, completion: {
            self.chatController.terminate()
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
        DispatchQueue.main.async {
           viewController.modalPresentationStyle = .fullScreen
           self.navigationController?.present(viewController, animated: false, completion: nil)
           viewController.viewControllers.first?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(BotDemoViewController.dismissChat(_:)))
        }
    }
    
    
//     func shouldPresent(_ form: BrandedForm!, handler completionHandler: (((UIViewController & BoldForm)?) -> Void)!) {
//         if (completionHandler != nil) {
//             DispatchQueue.main.async {
//                 if form.form?.type == BCFormTypePostChat {
//                 let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let postVC = mainStoryboard.instantiateViewController(withIdentifier: "boldForm") as! BoldFormViewController
//                    postVC.form = form
//                    completionHandler(postVC)
//                 } else {
//                     completionHandler(nil)
//                 }
//            }
//         }
//     }
    
    func didFailWithError(_ error: BLDError!) {
        var errorMsg = String()
        switch error.type {
             case BLDChatErrorTypeFailedToStart:
                 print("BLDChatErrorTypeFailedToStart")
                 errorMsg = "BLDChatErrorTypeFailedToStart"
                 break
             case BLDChatErrorTypeFailedToFinish:
                 print("BLDChatErrorTypeFailedToFinish")
                 errorMsg = "BLDChatErrorTypeFailedToFinish"
                 break
             case BLDChatErrorTypeFailedToSubmitForm:
                 print("BLDChatErrorTypeFailedToSubmitForm")
                 errorMsg = "BLDChatErrorTypeFailedToSubmitForm"
                 break
             case GeneralErrorType:
                 print("BLDChatErrorTypeGeneralErrorType")
                 errorMsg = "BLDChatErrorTypeGeneralErrorType"
                 break
             case BLDChatErrorTypeNoAccesseKeyForLiveChat:
                print("BLDChatErrorTypeNoAccesseKeyForLiveChat")
                errorMsg = "BLDChatErrorTypeNoAccesseKeyForLiveChat"
                 break
             case BLDChatErrorTypeNoImplementationForHandOver:
                print("BLDChatErrorTypeNoImplementationForHandOver")
                errorMsg = "BLDChatErrorTypeNoImplementationForHandOver"
                break
             default:
                 break
         }
        
        DispatchQueue.main.async {
           let alert = UIAlertController(title: "Error!", message: errorMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func didUpdateState(_ event: ChatStateEvent!) {
        switch event.state {
        case .preparing:
            print("ChatPreparing")
            break
        case .started:
            print("ChatStarted")
//            self.chatController.clearCache(withInvalidDays: 0)
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
    
//    func didClickUploadFile() {
//        
//    }
}

extension BotDemoViewController: ContinuityProvider {
    func updateContinuityInfo(_ params: [String : String]!) {
        params.forEach { (key, value) in
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    func fetchContinuity(forKey key: String!, handler: ((String?) -> Void)!) {
        if (key == "UserID") {
            handler("112233443322154534")
        } else {
//            handler(UserDefaults.standard.value(forKey: key) as? String)
            handler("112233443322154534")

        }
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


