//
//  ContinuityDemoViewController.swift
//  BasicSample
//
//  Created by Omer Rahmany on 01/09/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit
import Bold360AI

class ContinuityDemoViewController: AgentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chatController.continuityProvider = self
    }
}

extension ContinuityDemoViewController: ContinuityProvider{
    func updateContinuityInfo(_ params: [String : String]!) {
    }
    
    func fetchContinuity(forKey key: String!, handler: ((String?) -> Void)!) {
        handler(key)
    }
}
