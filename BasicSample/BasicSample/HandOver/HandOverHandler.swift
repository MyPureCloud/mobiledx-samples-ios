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
        let system = RemoteChatElement(type: .SystemMessageElement, content: "This is Hand Over\nType Stop to get back to Bot")
        system?.design = ChatElementDesignSystem
        system?.configuration = self.chatHandlerProvider?.configuration(for: .SystemMessageElement)
        self.delegate?.presentStatement(system!)
        
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
    }
    
    override func didStartTyping(_ isTyping: Bool) {
        
    }
    
    override func handleClickedLink(_ link: URL!) {
        
    }
    
    override func handleEvent(_ eventParams: [AnyHashable : Any]!) {
        
    }
    
    @objc func updateBubble(statement: StorableChatElement) {
        self.delegate?.update(.OK, element: statement)
        if statement.text == "Stop" {
            let system = RemoteChatElement(type: .SystemMessageElement, content: "Bye Bye from Over")
            system?.design = ChatElementDesignSystem
            system?.configuration = self.chatHandlerProvider?.configuration(for: .SystemMessageElement)
            self.delegate?.presentStatement(system!)
            self.chatHandlerProvider?.didEndChat(self)
        }
    }
}


