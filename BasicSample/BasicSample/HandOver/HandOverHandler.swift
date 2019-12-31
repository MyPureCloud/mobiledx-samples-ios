//
//  HandOverHandler.swift
//  BasicSample
//
//  Created by Nissim on 30/10/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit
import Bold360AI

class HandOverHandler: HandOver {
    
    
    override var isAutocompleteEnabled: Bool {
        return false
    }
    
    override func startChat(_ chatHandlerParams: [String : Any]?) {
        // Present system message
        
        
        // Do the connection to the chat provider
    }
    
    override func endChat() {
        
    }
    
    override func postStatement(_ statement: StorableChatElement) {
        
        // Configure the bubble
        statement.configuration = self.chatHandlerProvider?.configuration(for: .OutgoingElement)
        self.delegate?.presentStatement(statement)
        
        // Updated the double "V" sign for read notification
        self.perform(#selector(HandOverHandler.updateBubble(statement:)), with: statement, afterDelay: 3)
        
        // Just for testing you can cancel the handover by typing stop
        if statement.text == "Stop" {
            self.chatHandlerProvider?.didEndChat(self)
        }
    }
    
    override func didStartTyping(_ isTyping: Bool) {
        
    }
    
    override func handleClickedLink(_ link: URL!) {
        
    }
    
    override func handleEvent(_ eventParams: [AnyHashable : Any]!) {
        
    }
    
    @objc func updateBubble(statement: StorableChatElement) {
        self.delegate?.update(StatementStatus.Pending, element: statement)
    }
}


