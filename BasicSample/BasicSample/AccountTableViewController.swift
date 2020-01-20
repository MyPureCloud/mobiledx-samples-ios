//
//  AccountTableViewController.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 10/03/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit
import BoldAIEngine

protocol AccountTableViewControllerDelegate {
    func didPrepareAccount(handler: AccountHandler)
}

class AccountTableViewController: UITableViewController {
    
    var accountHandler: AccountHandler!
    let spinner = UIActivityIndicatorView()
//    var isSearch: Bool = false
//    var ChatPresentorViewController: BotDemoViewController!
    var delegate: AccountTableViewControllerDelegate?
    var faqPresentation: FAQPresentationType {
        return self.accountHandler.faqPresentation
    }
    var didFetchAccount: ((BotAccount) -> Void)?
    var startButtonTitle: String {
        get {
            return "Start Chat"
        }
    }
    var dataFileName: String!
    
    var startChatButton: UIBarButtonItem {
        get {
            return UIBarButtonItem(title: self.startButtonTitle, style: .plain, target: self, action: #selector(AccountTableViewController.startChat(sender:)))
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountHandler = AccountHandler(fileName: self.dataFileName)
        self.navigationItem.rightBarButtonItem = self.startChatButton
        self.tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "input")
        self.tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "switch")
        self.tableView.register(UINib(nibName: "ContextsTableViewCell", bundle: nil), forCellReuseIdentifier: "context")
        self.tableView.register(UINib(nibName: "AddContextTableViewCell", bundle: nil), forCellReuseIdentifier: "addContext")
        self.tableView.tableFooterView = UIView()
//        self.tableView.backgroundColor = UIColor(red: 244.0 / 255.0,
//                                                 green: 244.0 / 255.0,
//                                                 blue: 244.0 / 255.0,
//                                                 alpha: 1)
        self.tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func startChat(sender: UIBarButtonItem) {
//        spinner.sizeToFit()
//        spinner.startAnimating()
//        spinner.color = UIColor.lightGray
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        self.delegate?.didPrepareAccount(handler: self.accountHandler)
        self.didFetchAccount?(self.accountHandler.botAccount)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.accountHandler.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.accountHandler.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.type, for: indexPath) as! AccountDataTableViewCell
        
        cell.data = item
        cell.delegate = self
        // Configure the cell...
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return self.accountHandler.items[indexPath.row].type == "context"
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.accountHandler.deleteContext(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            self.perform(#selector(AccountTableViewController.updateAddContextState(status:)), with: true, afterDelay: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func updateAddContextState(status: NSNumber?) {
        if let stat = status {
            self.accountHandler.enableAddingContext = stat.boolValue
        }
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: self.accountHandler.items.count - 1, section: 0)], with: .none)
        self.tableView.endUpdates()
    }
}

extension AccountTableViewController: AccountDataTableViewCellDelegate {
    // MARK: AccountDataTableViewCellDelegate
    func onEvent(event: DataEvent) {
        switch event {
        case .addContext:
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                self.updateAddContextState(status: nil)
            }
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [self.accountHandler.addContext()], with: .bottom)
            self.tableView.endUpdates()
            CATransaction.commit()
            break
        case .contextValid:
            self.updateAddContextState(status: true)
            break
        default:
            self.updateAddContextState(status: false)
        }
        
    }
}
