//
//  ContextTableViewCell.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 05/03/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit

class ContextsTableViewCell: AccountDataTableViewCell {

    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    var isValid = false
    
    override var data: InputItemModel? {
        didSet {
            self.keyTextField.text = self.data?.key
            self.valueTextField.text = self.data?.value as? String
        }
    }

}

extension ContextsTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var name = self.keyTextField.text!
        var value = self.valueTextField.text!
        if textField == self.keyTextField {
            name += string
            if string.count == 0 {
                name.removeLast()
            }
        } else {
            value += string
            if string.count == 0 {
                value.removeLast()
            }
        }
        let isValid = name.count > 0 && value.count > 0
        if isValid {
            self.data?.key = name
            self.data?.value = value
            self.delegate?.onEvent(event: .contextValid)
        } else {
            self.data?.key = ""
            self.data?.value = ""
            self.delegate?.onEvent(event: .contextInValid)
        }
        return true
    }
}
