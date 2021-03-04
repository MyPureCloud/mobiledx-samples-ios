// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class MainTableViewController: UITableViewController {
    var demos: [[String: String]]!
    var boldController: UIViewController?
    var configHandler = ConfigFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.demos = self.extarctPlist
        self.title = "Bold360 SDK Demos"
    }

    // MARK: - Table view data source
    
    @IBAction func changeColorType(_ sender: UISegmentedControl) {
        self.configHandler.colorType = ColorType(rawValue: sender.selectedSegmentIndex) ?? .basic
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.demos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DemoTableViewCell

        // Configure the cell...
        cell.model = self.demos[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let switcher = Bundle.main.loadNibNamed("ColorTypeSwitcher", owner: self, options: nil)?.first as? UIView
        switcher?.frame = CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 44))
        return switcher
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accountVC = AccountTableViewController()
        accountVC.dataFileName = "InitObj"
        switch indexPath.row {
        case 1:
            var liveVC: LiveAccountViewController?
            if #available(iOS 13.0, *) {
                liveVC = self.storyboard?.instantiateViewController(identifier: "LiveAccountViewController")
            } else {
                liveVC = self.storyboard?.instantiateViewController(withIdentifier: "LiveAccountViewController") as? LiveAccountViewController
            }
            liveVC?.loadChat = {
                let account = LiveAccount()
                account.apiKey = $0
                self.boldController = AgentViewController()
                (self.boldController as? AgentViewController)?.account = account
                (self.boldController as? AgentViewController)?.chatConfiguration = self.configHandler.chatConfig
                self.performSegue(withIdentifier: "presentChat", sender: self.boldController)
            }
            self.navigationController?.present(liveVC!, animated: true, completion: nil)
            return
        case 2:
            boldController = HistoryDemoViewController()
            break
        case 3:
            boldController = RestoreChatDemoViewController()
            break
        case 4:
            boldController = FileUploadDemoViewController()
            break
        case 5:
            boldController = CustomFileUploadDemoVC()
        case 6:
            boldController = self.storyboard?.instantiateViewController(withIdentifier: "Embed")
            break
        case 7:
            accountVC.dataFileName = "InitObjSearch"
            accountVC.didFetchAccount =  { account in
                NanoRep.shared()?.prepare(with: account)
                            NanoRep.shared()?.fetchConfiguration = { (configuration: NRConfiguration?, error: Error?) -> Void in
                                guard let config = configuration else {
                                    print(error.debugDescription)
                                    return
                                }
                                config.faqPresentationType = accountVC.faqPresentation
                                DispatchQueue.main.async {
                                    let widgetViewController = NRWidgetViewController()
                                    self.navigationController?.pushViewController(widgetViewController, animated: true)
                                }
                            }
            }
            self.navigationController?.pushViewController(accountVC, animated: true)
            return
        case 8:
            accountVC.didFetchAccount = {
                self.performSegue(withIdentifier: "AutoComplete", sender: $0)
            }
            self.navigationController?.pushViewController(accountVC, animated: true)
            return
        case 9:
            let account = BotAccount()
            account.account = "{YOUR_ACCOUNT}"
            account.knowledgeBase = "{YOUR_KB}"
        default:
            boldController = BotDemoViewController()
            (boldController as? BotDemoViewController)?.chatConfiguration = self.configHandler.chatConfig
            break
        }
        
        if #available(iOS 13.0, *) {
            accountVC.view.backgroundColor = .systemBackground
        }
        
        accountVC.dataFileName = "InitObj"
        accountVC.delegate = self
        self.navigationController?.pushViewController(accountVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AvailibilityViewController {
            controller.chatVC = sender as? BotDemoViewController
        } else if let controller = segue.destination as? AutoCompleteViewController {
            controller.account = sender as? Account
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData()
    }

    var extarctPlist: [[String: String]]? {
        if let path = Bundle.main.path(forResource: "Demos", ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) as? [[String: String]] {
                return array
            }
        }
        return nil
    }

}

extension MainTableViewController: AccountTableViewControllerDelegate {
    func didPrepareAccount(handler: AccountHandler) {
        guard let controller = self.boldController as? BotDemoViewController else {
            return
        }
        controller.account = handler.botAccount
        if let historyController = controller as? HistoryDemoViewController {
            historyController.storeWelcomeMessage = handler.withWelcomeMessage
        }
         self.navigationController?.pushViewController(controller, animated: true)
    }
}
