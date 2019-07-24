// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class AvailibilityViewController: UIViewController {
    var chatVC: BotDemoViewController!
    @IBOutlet weak var availabilityBtn: UIButton!
    @IBOutlet weak var startChatBtn: UIButton!
    
    @IBAction func presentChat(_ sender: Any) {
        self.navigationController?.pushViewController(self.chatVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshAvailability(self)        
    }
    
    @IBAction func refreshAvailability(_ sender: Any) {
        self.availabilityBtn.setBackgroundImage(nil, for: UIControl.State.normal)
       
        ChatController.checkAvailability(self.createAccount()) { (isAvailable, reason, error) in
            print("refreshed availability")
            
            self.availabilityBtn.setBackgroundImage(#imageLiteral(resourceName: "availability"), for: .normal)
            
            if isAvailable {
                self.availabilityBtn.tintColor = UIColor.green
                self.startChatBtn.isEnabled = true
            } else {
                self.availabilityBtn.tintColor = UIColor.red
                self.startChatBtn.isEnabled = false
            }
        }
    }
    
    func createAccount() -> Account {
        let liveAccount = LiveAccount()
        liveAccount.apiKey = "2300000001700000000:2279145895771367548:MGfXyj9naYgPjOZBruFSykZjIRPzT1jl"
        return liveAccount
    }
}
