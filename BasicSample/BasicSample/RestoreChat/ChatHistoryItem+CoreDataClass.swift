// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import Foundation
import CoreData
import Bold360AI


public class ChatHistoryItem: NSManagedObject, StorableChatElement {
    
    public var feedbackStatus: FeedbackStatus {
        return FeedbackStatus(rawValue: Int(self.likeStatus)) ?? .default
    }
    
    public var articleId: NSNumber {
        set {
            self.messageId = newValue.stringValue
        }
        
        get {
            if let num = Int64(messageId) {
                return NSNumber(value: num)
            }
            return 0
        }
    }
    
    public var readoutMessage: ReadoutMessage?
    
    public var userInputType: String!
    
    public var storageKey: String! {
        get {
            return self.json
        }
    }
    
    public var statementScope: StatementScope {
        set {
            self.scope = Int16(newValue.rawValue)
        }
        get {
            return StatementScope(rawValue: Int32(Int16(Int(self.scope)))) 
        }
    }
    
    public var status: StatementStatus {
        set {
            self.itemStatus = Int16(newValue.rawValue)
        }
        get {
            return StatementStatus(rawValue: Int(self.itemStatus)) ?? StatementStatus.Pending
        }
    }
    
    public var elementId: NSNumber! {
        return self.itemId as NSNumber
    }
    
    public var type: ChatElementType {
        return ChatElementType(rawValue: Int(self.itemType)) ?? ChatElementType.OutgoingElement
    }
    
    public var timestamp: Date! {
        return self.timeStamp as Date?
    }
    
    public var text: String! {
        get {
            return self.itemText
        }
        set {
            self.itemText = newValue
        }
    }
    
    public var source: ChatElementSource {
        set {
            self.itemSource = Int16(newValue.rawValue)
        }
        get {
            return ChatElementSource(rawValue: Int(self.itemSource)) ?? ChatElementSource.history
        }
    }
    
    public var configuration: MessageConfiguration!
    
    public var removable: Bool {
        set {
            self.isRemovable = newValue
        }
        get {
            return self.isRemovable
        }
    }
    
    
    
    
    
    public var element: StorableChatElement! {
        didSet {
            self.itemId = self.element.elementId.int64Value
            self.itemType = Int16(self.element.type.rawValue)
            
            self.timeStamp = self.element.timestamp as NSDate
            self.itemText = self.element.text
            self.itemSource = Int16(self.element.source.rawValue)
            self.isRemovable = self.element.removable
            if let context = self.managedObjectContext {
                self.config = NSEntityDescription.insertNewObject(forEntityName: "ChatConfiguration", into: context) as? ChatConfiguration
                self.config?.configuration = self.element.configuration
            }
            if let id = self.element.articleId?.stringValue {
                self.messageId = id
            }
            
            self.likeStatus = Int16(self.element.feedbackStatus.rawValue)
            self.itemStatus = Int16(self.element.status.rawValue)
            self.scope = Int16(self.element.statementScope.rawValue)
            self.json = self.element.storageKey
        }
    }
    
    
    
    
    
}
