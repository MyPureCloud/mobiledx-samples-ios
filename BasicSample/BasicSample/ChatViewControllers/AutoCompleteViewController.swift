//
//  AutoCompleteViewController.swift
//  BasicSample
//
//  Created by Nissim on 20/08/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit
import Bold360AI

class AutoCompleteViewController: UIViewController {
    
    var account: Account!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AutoCompleteViewController.keyboardPresented(_:)),
                                               name: UIWindow.keyboardWillShowNotification ,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AutoCompleteViewController.keyboardDismissed(_:)),
                                               name: UIWindow.keyboardWillHideNotification ,
                                               object: nil)
    }
    

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let controller = segue.destination as? SearchViewController else {
            return
        }
        if segue.identifier == "Top" {
            controller.autoCompleteOnTop = true
            
            // Testing configuration
            let config = SearchViewConfiguration()
            let autoCompleteConfig = AutoCompleteConfiguration()
            autoCompleteConfig.textColor = UIColor.red
            config.autoCompleteConfiguration = autoCompleteConfig
            controller.configuration = config
        }
        
        controller.delegate = self
        controller.account = self.account
        controller.view.layer.borderColor = UIColor.red.cgColor
        controller.view.layer.borderWidth = 2.0
    }
    
    @objc func keyboardPresented(_ notification: NSNotification) {
        if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            guard let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
                self.bottomConstraint.constant = value.cgRectValue.height
                return
            }
            self.bottomConstraint.constant = value.cgRectValue.height - bottom
            if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
                UIView.animate(withDuration: duration) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
    }
    
    @objc func keyboardDismissed(_ notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }

}

extension AutoCompleteViewController: SearchViewControllerDelegate {
    func didSelectSuggestion(_ suggestion: [String : NSCopying]) {
        
    }
    
    func didSubmitText(_ text: String) {
        
    }
    
    func speechRecognitionDidFail(with status: NRSpeechRecognizerAuthorizationStatus) {
        
    }
    
    func updateHeight(with diffHeight: CGFloat) {
//        self.chatHeightConstraint.constant += diffHeight
    }
    
    
}
