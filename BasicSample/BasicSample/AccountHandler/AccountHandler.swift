//
//  AccountHandler.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 05/03/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit
import BoldAIEngine

class AccountHandler: NSObject {
    var items = [InputItemModel]()
    var rawData: [[String: Any]]!
    var withWelcomeMessage = true
    var urlIsInternal = true
    var skipPrechat = false
    var enableHistroy = false
    var faqPresentation: FAQPresentationType = .basic
    var enableAddingContext: Bool? {
        didSet {
            self.items.last?.value = self.enableAddingContext
        }
    }
    var fileName: String!
    
    var botAccount: BotAccount {
        get {
            self.rawData.removeAll()
            self.items.forEach { (item) in
                self.rawData.append(item.params)
            }
            UserDefaults.standard.set(self.rawData, forKey: self.fileName)
            UserDefaults.standard.synchronize()
            var contexts: [InputItemModel]?
            var nanorepContext: [String: String]?
            let botAccount = BotAccount()
            self.items.forEach { (item) in
                switch item.key {
                case "account":
                    botAccount.account = item.value as? String
                    break
                case "kb":
                    botAccount.knowledgeBase = item.value as? String
                    break
                case "apiKey":
                    botAccount.apiKey = item.value as? String
                    break
                case "server":
                    botAccount.perform(Selector.init(("setServer:")), with:item.value as? String)
                    break
                case "withWelcome":
                    self.withWelcomeMessage = item.value as? Bool ?? false
                    break
                case "urlIsInternal":
                    self.urlIsInternal = item.value as? Bool ?? false
                    break
                case "enableHistory":
                    self.enableHistroy = item.value as? Bool ?? false
                    break
                case "supportCenterEnabled":
                    if let val = item.value as? Bool, val {
                        self.faqPresentation = .supportCenter
                    }
                    break
                case "allContextsMandatory":
                    botAccount.allContextsMandatory = item.value as? Bool ?? false
                    break
                default:
                    if contexts == nil {
                        contexts = [InputItemModel]()
                        nanorepContext = [String: String]()
                    }
                    contexts?.append(item)
                    break
                }
            }
            contexts?.forEach({ (item) in
                if let val = item.value as? String {
                    nanorepContext?[item.key] = val
                }
            })
            botAccount.nanorepContext = nanorepContext
            return botAccount
        }
    }
    
    init(fileName: String) {
        super.init()
        self.fileName = fileName
        self.rawData = UserDefaults.standard.array(forKey: fileName) as? [[String: Any]]
        if self.rawData == nil {
            if let path = Bundle.main.path(forResource: fileName, ofType: "plist") {
                self.rawData = NSArray(contentsOfFile: path) as? [[String: Any]]
            }
        }
        self.rawData.forEach({ (item) in
            self.items.append(InputItemModel(params: item))
        })
    }
    
    func addContext() -> IndexPath {
        self.enableAddingContext = false
        let idxPath = IndexPath(row: self.items.count - 1, section: 0)
        let newData = InputItemModel()
        newData.type = "context"
        self.items.insert(newData, at: idxPath.row)
        self.rawData.insert(newData.params, at: idxPath.row)
        return idxPath
    }
    
    func deleteContext(index: Int)  {
        self.enableAddingContext = true
        self.items.remove(at: index)
        self.rawData.remove(at: index)
    }
}
