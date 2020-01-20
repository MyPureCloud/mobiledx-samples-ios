//
//  InputTableViewCell.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 05/03/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit

class InputTableViewCell: AccountDataTableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    override var data: InputItemModel? {
        didSet {
            self.textField.placeholder = data?.hint
            self.textField.text = data?.value as? String
        }
    }

}

extension InputTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var text = textField.text! + string;
        if string.count == 0 {
            text.removeLast()
        }
        self.data?.value = text
        return true
    }
}
