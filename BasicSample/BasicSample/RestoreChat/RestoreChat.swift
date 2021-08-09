// ===================================================================================================
// Copyright © 2019 bold360ai(LogMeIn).
// Bold360AI SDK.
// All rights reserved.
// ===================================================================================================

import UIKit
import Bold360AI
import CoreData

enum RestoreChatState {
    case prsented
    case dismissed
    case pending
}

protocol RestoreChatDelegate {
    func didReceiveBackgroundMessage(_ message: StorableChatElement)
}

class RestoreChat: NSObject, ChatElementDelegate {
    func didReceive(_ item: StorableChatElement!) {
        if (item.type != .SystemMessageElement) {
            let _item = NSEntityDescription.insertNewObject(forEntityName: "ChatHistoryItem", into: self.managedContext) as! ChatHistoryItem
            _item.element = item
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error)")
            }
            if self.state == .dismissed {
                self.delegate?.didReceiveBackgroundMessage(item)
            }
            guard let group = self.group else {
                let _group = NSEntityDescription.insertNewObject(forEntityName: "ChatHistoryGroup", into: self.managedContext) as! ChatHistoryGroup
                _group.groupId = self.groupId
                _group.addToItems(_item)
                return
            }
            group.addToItems(_item)
        }
    }
    
    
    var managedContext: NSManagedObjectContext!
    var state = RestoreChatState.pending
    var delegate: RestoreChatDelegate?
    var groupId: String?
    
    init(_ context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    var group: ChatHistoryGroup? {
        let fetchRequest = NSFetchRequest<ChatHistoryGroup>(entityName: "ChatHistoryGroup")
        guard self.groupId != nil else {
            print("fetch failed - no data for id - \(self.groupId!)")
            return nil
        }
        fetchRequest.predicate = NSPredicate(format: "groupId == %@", self.groupId!)
        do {
            let result = try self.managedContext.fetch(fetchRequest)
            return result.first
        } catch {
            print("fetch failed")
        }
        return nil
    }
    
    func fetch(_ from: Int, handler: (([StorableChatElement]?) -> Void)!) {
        if let items = self.group?.items {
            let temp = items.allObjects as! [ChatHistoryItem]
            let sorted = temp.sorted { (first, second) -> Bool in
                first.timeStamp?.compare(second.timeStamp! as Date) == ComparisonResult.orderedAscending
            }
            handler(sorted)
            return
        }
        handler(nil)
    }
    
    func remove(_ timestampId: TimeInterval) {
        
    }
    
    func didUpdateChatElement(_ timestampId: TimeInterval, newTimestamp: TimeInterval, status: StatementStatus) {
        let fetchRequest = NSFetchRequest<ChatHistoryItem>(entityName: "ChatHistoryItem")
        let id = Int64(timestampId)
        fetchRequest.predicate = NSPredicate(format: "itemId == %@", NSNumber(value: id))
        do {
            let result = try self.managedContext.fetch(fetchRequest)
            if let item = result.first {
                item.itemStatus = Int16(status.rawValue)
                didReceive(item.element)
                self.managedContext.delete(result.first!)
            }
        } catch {
            print("fetch failed")
        }
    }
    
    func didUpdateFeedback(_ articleId: String!, feedbackState: FeedbackStatus) {
        let fetchRequest = NSFetchRequest<ChatHistoryItem>(entityName: "ChatHistoryItem")
        fetchRequest.predicate = NSPredicate(format: "messageId == %@", articleId)
        do {
            let result = try self.managedContext.fetch(fetchRequest)
            
            // We can get multiple articles with the same article id
            result.forEach { (item) in
                item.likeStatus = Int16(feedbackState.rawValue)
            }
            do {
                try self.managedContext.save()
            }
        } catch {
            print("fetch failed")
        }
    }
}
