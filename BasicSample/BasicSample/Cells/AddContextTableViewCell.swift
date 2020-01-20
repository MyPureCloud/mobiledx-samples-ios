//
//  AddContextTableViewCell.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 05/03/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit

class AddContextTableViewCell: AccountDataTableViewCell {

    @IBOutlet weak var addButton: OptionButton!

    
    override var data: InputItemModel? {
        didSet {
            self.addButton.setTitle(self.data?.hint, for: .normal)
            if let enable = self.data?.value as? Bool {
                self.addButton.isEnabled = enable
            }
        }
    }
    
    
    @IBAction func addContext(_ sender: OptionButton) {
        self.delegate?.onEvent(event: .addContext)
    }
    
}
