// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class AvailibilityViewController: UIViewController {
    var chatVC: BotDemoViewController!
    
    private var departments: [Department] = []
    @IBOutlet weak var availabilityBtn: UIButton!
    @IBOutlet weak var startChatBtn: UIButton!
    @IBOutlet weak var departmentsTableView: UITableView!
    
    @IBAction func presentChat(_ sender: Any) {
        self.navigationController?.pushViewController(self.chatVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.departmentsTableView.dataSource = self
        self.departmentsTableView.delegate = self
        self.fetchDepartments(self)
    }
    
    @IBAction func fetchDepartments(_ sender: Any) {
        self.availabilityBtn.tintColor = UIColor.red
        self.startChatBtn.isEnabled = false
        
        ChatController.fetchDepartments(self.chatVC.account) { result in
            if let departments = result.departments {
                self.departments = departments
                self.departmentsTableView.reloadData()
            }
        }
    }
}

extension AvailibilityViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentId")
        let department = self.departments[indexPath.row]
        cell?.textLabel?.text = department.name
        
        return cell!
    }
}

extension AvailibilityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (chatVC.account as? LiveAccount)?.extraData.departmentId = self.departments[indexPath.row].departmentId
        
        ChatController.checkAvailability(chatVC.account) { (availabilityResult) in
            print("refreshed availability")
            
            self.availabilityBtn.setBackgroundImage(#imageLiteral(resourceName: "availability"), for: .normal)
            
            if availabilityResult.isAvailable {
                self.availabilityBtn.tintColor = UIColor.green
                self.startChatBtn.isEnabled = true
            } else {
                self.availabilityBtn.tintColor = UIColor.red
                self.startChatBtn.isEnabled = false
            }
        }

    }
}
