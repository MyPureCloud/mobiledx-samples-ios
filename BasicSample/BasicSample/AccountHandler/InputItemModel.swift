//
//  InputItemModel.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 27/02/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit


class InputItemModel: NSObject {
    var key: String! {
        didSet {
            self.params?["key"] = self.key
        }
    }
    var value: Any! {
        didSet {
            self.params?["value"] = self.value
        }
    }
    var hint: String!
    var type: String! {
        didSet {
            self.params?["type"] = self.type
        }
    }
    var params: [String: Any]!
    
    
    override init() {
        super.init()
        self.params = [String: Any]()
    }
    
    init(params: [String: Any]) {
        super.init()
        self.params = params
        self.key = params["key"] as? String
        self.hint = params["hint"] as? String
        self.type = params["type"] as? String
        self.value = params["value"]
    }
}
