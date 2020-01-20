//
//  LiveAccountViewController.swift
//  BasicSample
//
//  Created by Nissim on 20/01/2020.
//  Copyright © 2020 bold360ai. All rights reserved.
//

import UIKit


class LiveAccountViewController: UIViewController {
    
    @IBOutlet weak var accessKeyTF: UITextField!
    var loadChat: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loadChat(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.loadChat?(self.accessKeyTF.text)
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
