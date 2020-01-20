//
//  AccountDataTableViewCell.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 05/03/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit

enum DataEvent {
    case addContext
    case contextValid
    case contextInValid
}

protocol AccountDataTableViewCellDelegate {
    func onEvent(event: DataEvent)
}

class AccountDataTableViewCell: UITableViewCell {
    
    var data: InputItemModel?
    var delegate: AccountDataTableViewCellDelegate?

}
