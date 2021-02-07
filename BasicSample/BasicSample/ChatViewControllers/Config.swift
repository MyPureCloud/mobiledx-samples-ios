//
//  Config.swift
//  BasicSample
//
//  Created by user on 04/02/2021.
//  Copyright © 2021 bold360ai. All rights reserved.
//

import Foundation
import Bold360AI

enum ColorType: Int {
    case basic = 0, asset = 1, system = 2
}

class ConfigFactory {
    
    var colorType: ColorType = ColorType.basic {
        didSet {
            self.updateConfig()
        }
    }


    var customFont:CustomFont = CustomFont()
    var image:UIImage = UIImage()

    var dateFormatterGet = DateFormatter()
    var timeFormatterGet = DateFormatter()
    
    lazy var chatConfig = {
        Bold360AI.ChatConfiguration()
    }()
    
    func updateConfig() {
        self.image = UIImage(named: "agent")!
        self.customFont.font = UIFont.italicSystemFont(ofSize: 30)
        self.dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timeFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.updateLiveIncoming()
        self.updateBotIncoming()
        self.updateMultiLine()
        self.updateOutgoing()
    }
    
    func updateLiveIncoming() {
//        self.chatConfig.incomingLiveConfig.backgroundColor = self.bgColor // not working as expected - setting this value changes the bgColor of the systemMessage. To change the bgColor of the live agent we need to change the bgColor of incomingBot
//        self.chatConfig.incomingLiveConfig.textColor = self.textColor  // not working as expected - setting this value changes the text color of the systemMessage. To change the textColor of the live agent we need to change the textColor of incomingBot
//        self.chatConfig.incomingLiveConfig.customFont = customFont // not working as expected - setting this value changes the font of the systemMessage. To change the font of the live agent we need to change the font of incomingBot
//
//        self.chatConfig.incomingLiveConfig.avatar = self.image // working
//        self.chatConfig.incomingLiveConfig.avatarPosition = AvatarPosition.bottomRight // working
//
//        self.chatConfig.incomingLiveConfig.dateFormatter = self.dateFormatterGet // working
//        self.chatConfig.incomingLiveConfig.timeFormatter = self.timeFormatterGet// working
//        self.chatConfig.incomingLiveConfig.dateStampColor = UIColor(named: "textColor") // not working as expected for dark mode. only by killing the app do we get the darkMode/LightMode changes
//        self.chatConfig.incomingLiveConfig.dateStampFont = self.customFont.font // working
//
//        self.chatConfig.incomingLiveConfig.maxLength = 3 // Not working
//
//        self.chatConfig.incomingLiveConfig.backgroundImage = UIImage(named: "agent")! // Not working
//        self.chatConfig.incomingLiveConfig.borderRadius = BorderRadius(top: Corners(left: 80, right: 80 ), bottom: Corners(left: 40, right: 40 )) // working
        
        updateChatElement(chatElementConfiguration: self.chatConfig.incomingLiveConfig!)
        self.updateSystemMessage()
    }
    
    func updateSystemMessage() {
//        self.chatConfig.systemMessageConfig.backgroundColor = self.bgColor // working
//        self.chatConfig.systemMessageConfig.textColor =  self.textColor // working
//        self.chatConfig.systemMessageConfig.customFont = customFont // not working
//
//        self.chatConfig.systemMessageConfig.avatar = self.image // working
//        self.chatConfig.systemMessageConfig.avatarPosition = AvatarPosition.bottomRight // working
//        self.chatConfig.systemMessageConfig.borderRadius = BorderRadius(top: Corners(left: 0, right: 40 ), bottom: Corners(left: 40, right: 40 ))
//
//        self.chatConfig.systemMessageConfig.dateFormatter = self.dateFormatterGet // working
//        self.chatConfig.systemMessageConfig.timeFormatter = self.timeFormatterGet // Not working - there is no time for the system messages
//        self.chatConfig.systemMessageConfig.dateStampColor = self.textColor // Not working - there is no dateStamp for the system messages
//        self.chatConfig.systemMessageConfig.dateStampFont = self.customFont.font // Not working - there is no dateStamp for the system messages
//
//        self.chatConfig.systemMessageConfig.maxLength = 3 // Not working
//
//        self.chatConfig.systemMessageConfig.backgroundImage = self.image // Not working
        
        updateChatElement(chatElementConfiguration: self.chatConfig.systemMessageConfig!)
    }
    
    func updateOutgoing() {
//        self.chatConfig.outgoingConfig.backgroundColor = self.bgColor
//        self.chatConfig.outgoingConfig.textColor =  self.textColor
//        self.chatConfig.outgoingConfig.customFont = customFont
//
//        self.chatConfig.outgoingConfig.avatar = self.image
//        self.chatConfig.outgoingConfig.avatarPosition = AvatarPosition.topLeft
//        self.chatConfig.outgoingConfig.borderRadius = BorderRadius(top: Corners(left: 0, right: 40 ), bottom: Corners(left: 40, right: 40 ))
//
//        self.chatConfig.outgoingConfig.dateFormatter = self.dateFormatterGet
//        self.chatConfig.outgoingConfig.timeFormatter = self.timeFormatterGet
//        self.chatConfig.outgoingConfig.dateStampColor = self.textColor
//        self.chatConfig.outgoingConfig.dateStampFont = self.customFont.font
//
//        self.chatConfig.outgoingConfig.maxLength = 3
//
//        self.chatConfig.outgoingConfig.backgroundImage = self.image
        
        updateChatElement(chatElementConfiguration: self.chatConfig.outgoingConfig!)
    }
    
    func updateBotIncoming() {
//        self.chatConfig.incomingBotConfig.backgroundColor = self.bgColor
//        self.chatConfig.incomingBotConfig.textColor = self.textColor
        
        updateChatElement(chatElementConfiguration: self.chatConfig.incomingBotConfig!)

        self.updateQuickOptions()
    }
    
    func updateMultiLine() {
//        self.chatConfig.multipleSelectionConfiguration.backgroundColor = self.bgColor
//        self.chatConfig.multipleSelectionConfiguration.textColor =  self.textColor
//        self.chatConfig.multipleSelectionConfiguration.customFont = customFont
//
//        self.chatConfig.multipleSelectionConfiguration.avatar = self.image
//        self.chatConfig.multipleSelectionConfiguration.avatarPosition = AvatarPosition.topLeft
//        self.chatConfig.multipleSelectionConfiguration.borderRadius = BorderRadius(top: Corners(left: 0, right: 40 ), bottom: Corners(left: 40, right: 40 ))
//
//        self.chatConfig.multipleSelectionConfiguration.dateFormatter = self.dateFormatterGet
//        self.chatConfig.multipleSelectionConfiguration.timeFormatter = self.timeFormatterGet
//        self.chatConfig.multipleSelectionConfiguration.dateStampColor = self.textColor
//        self.chatConfig.multipleSelectionConfiguration.dateStampFont = self.customFont.font
//
//        self.chatConfig.multipleSelectionConfiguration.maxLength = 3
//
//        self.chatConfig.multipleSelectionConfiguration.backgroundImage = self.image
        
        updateChatElement(chatElementConfiguration: self.chatConfig.multipleSelectionConfiguration!)

        
        updatePersistentOptionsTitle()
        updatePersistentOptions()
    }
    
    func updatePersistentOptionsTitle() {
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.backgroundColor = self.bgColor
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.textColor = self.textColor
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.customFont = self.customFont
    }
    
    func updatePersistentOptions() {
        self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.backgroundColor = self.bgColor
        self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.textColor = self.textColor
        self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.customFont = self.customFont
    }
    
    func updateQuickOptions() {
//        self.chatConfig.incomingBotConfig.quickOptionConfig.backgroundColor = self.bgColor
//        self.chatConfig.incomingBotConfig.quickOptionConfig.textColor = self.textColor
//        self.chatConfig.incomingBotConfig.quickOptionConfig.customFont = self.customFont
//
//        self.chatConfig.incomingBotConfig.quickOptionConfig.avatar = self.image
//        self.chatConfig.incomingBotConfig.quickOptionConfig.avatarPosition = AvatarPosition.topLeft
//        self.chatConfig.incomingBotConfig.quickOptionConfig.borderRadius = BorderRadius(top: Corners(left: 0, right: 40 ), bottom: Corners(left: 40, right: 40 ))
//
//        self.chatConfig.incomingBotConfig.quickOptionConfig.dateFormatter = self.dateFormatterGet
//        self.chatConfig.incomingBotConfig.quickOptionConfig.timeFormatter = self.timeFormatterGet
//        self.chatConfig.incomingBotConfig.quickOptionConfig.dateStampColor = self.textColor
//        self.chatConfig.incomingBotConfig.quickOptionConfig.dateStampFont = self.customFont.font
//
//        self.chatConfig.incomingBotConfig.quickOptionConfig.maxLength = 3
//
//        self.chatConfig.incomingBotConfig.quickOptionConfig.backgroundImage = self.image
        
        updateChatElement(chatElementConfiguration: self.chatConfig.incomingBotConfig.quickOptionConfig!)
    }
    
    func updateChatElement(chatElementConfiguration: ChatElementConfiguration) {
        chatElementConfiguration.backgroundColor = self.bgColor
        chatElementConfiguration.textColor = self.textColor
        chatElementConfiguration.customFont = self.customFont
                
        chatElementConfiguration.avatar = self.image
        chatElementConfiguration.avatarPosition = AvatarPosition.topLeft
        chatElementConfiguration.borderRadius = BorderRadius(top: Corners(left: 0, right: 40 ), bottom: Corners(left: 40, right: 40 ))

        chatElementConfiguration.dateFormatter = self.dateFormatterGet
        chatElementConfiguration.timeFormatter = self.timeFormatterGet
        chatElementConfiguration.dateStampColor = self.textColor
        chatElementConfiguration.dateStampFont = self.customFont.font

        chatElementConfiguration.maxLength = 3

        chatElementConfiguration.backgroundImage = self.image
    }
    
    
    var bgColor: UIColor {
        switch self.colorType {
        case .basic:
            return UIColor.red
        case .asset:
            return UIColor(named: "bgColor")!
        case .system:
            return UIColor.systemRed
        }
        
    }
    
    var textColor: UIColor {
        switch self.colorType {
        case .basic:
            return UIColor.blue
        case .asset:
            return UIColor(named: "textColor")!
        case .system:
            return UIColor.systemBlue
        }
        
    }
}



