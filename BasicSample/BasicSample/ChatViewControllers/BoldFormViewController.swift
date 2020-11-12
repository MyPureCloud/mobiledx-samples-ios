// ===================================================================================================
// Copyright © 2020 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================


import UIKit
import Bold360AI

class BoldFormViewController: UIViewController {
    var chatController: ChatController!
    var formInfo: BrandedForm!
    var formDelegate: BoldFormDelegate!

    @IBOutlet weak var formTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let formField = self.formInfo.form.formFields.first as? BCFormField{
            self.formTitle.text = formField.label
        }
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        (self.formInfo.form.formFields.first as? BCFormField)?.label = self.formTitle.text
        self.delegate.submitForm(self.form)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.delegate.submitForm(nil)
        super.viewDidDisappear(animated);
    }
}

    
    
extension BoldFormViewController: BoldForm {
    var form: BrandedForm! {
        get {
            return formInfo
        }
        set(form) {
            formInfo = form
        }
    }
    
    var delegate: BoldFormDelegate! {
        get {
            return formDelegate
        }
        set(delegate) {
            formDelegate = delegate
        }
    }
}
