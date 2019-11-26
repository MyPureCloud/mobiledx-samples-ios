// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI

class MainTableViewController: UITableViewController {
    var demos: [[String: String]]!
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var boldController: UIViewController?
        switch indexPath.row {
        case 1:
            boldController = AgentViewController()
            self.performSegue(withIdentifier: "presentChat", sender: boldController)
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
            break
        case 6:
            boldController = self.storyboard?.instantiateViewController(withIdentifier: "Embed")
            break
        case 7:
            let account = BotAccount()
            account.account = "{YOUR_ACCOUNT}"
            account.knowledgeBase = "{YOUR_KB}"
            NanoRep.shared()?.prepare(with: account)
            NanoRep.shared()?.fetchConfiguration = { (configuration: NRConfiguration?, error: Error?) -> Void in
                guard let config = configuration else {
                    print(error.debugDescription)
                    return
                }
                config.useLabels = true
                DispatchQueue.main.async {
                    let widgetViewController = NRWidgetViewController()
//                    widgetViewController.infoHandler = self
//                    widgetViewController.applicationHandler = self
                    self.navigationController?.pushViewController(widgetViewController, animated: true)
//                    self.navigationController?.present(widgetViewController, animated: true, completion: nil)
                }
            }

            break
        case 8:
            let account = BotAccount()
            account.account = "{YOUR_ACCOUNT}"
            account.knowledgeBase = "{YOUR_KB}"
            self.performSegue(withIdentifier: "AutoComplete", sender: account)
            return
        case 9:
            let account = BotAccount()
            account.account = "{YOUR_ACCOUNT}"
            account.knowledgeBase = "{YOUR_KB}"
            
        default:
            boldController = BotDemoViewController()
            break
        }
        if let controller = boldController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    var extarctPlist: [[String: String]]? {
        if let path = Bundle.main.path(forResource: "Demos", ofType: "plist") {
            if let array = NSArray(contentsOfFile: path) as? [[String: String]] {
                return array
            }
        }
        return nil
    }

}
