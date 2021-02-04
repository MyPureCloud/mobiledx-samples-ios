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
    }
    
    func updateLiveIncoming() {
        self.chatConfig.incomingLiveConfig.backgroundColor = self.bgColor
        self.chatConfig.incomingLiveConfig.textColor = self.textColor
        self.chatConfig.incomingLiveConfig.customFont = customFont // not working as expected - setting this value changes the font of the systemMessage. To change the font of the live agent we need to change the font of incomingBot
        
//        self.chatConfig.incomingLiveConfig.avatar = self.image
//        self.chatConfig.incomingLiveConfig.avatarPosition = AvatarPosition.bottomRight
//
//        self.chatConfig.incomingLiveConfig.dateFormatter = self.dateFormatterGet
//        self.chatConfig.incomingLiveConfig.timeFormatter = self.timeFormatterGet
//        self.chatConfig.incomingLiveConfig.dateStampColor = self.textColor
//        self.chatConfig.incomingLiveConfig.dateStampFont = self.customFont.font
//
//        self.chatConfig.incomingLiveConfig.maxLength = 3
//
//        self.chatConfig.incomingLiveConfig.backgroundImage = self.image // Not working
//        self.chatConfig.incomingLiveConfig.borderRadius = BorderRadius(top: Corners(left: 40, right: 40 ), bottom: Corners(left: 40, right: 40 ))
//        self.chatConfig.incomingLiveConfig.borderRadius.top = Corners(left: 40, right: 40 )
        
        
        self.updateSystemMessage()
    }
    
    func updateSystemMessage() {
        self.chatConfig.systemMessageConfig.backgroundColor = self.bgColor
        self.chatConfig.systemMessageConfig.textColor = self.textColor
        self.chatConfig.systemMessageConfig.customFont = customFont
        
        self.chatConfig.systemMessageConfig.avatar = self.image
        self.chatConfig.systemMessageConfig.avatarPosition = AvatarPosition.bottomRight
        
        self.chatConfig.systemMessageConfig.dateFormatter = self.dateFormatterGet
        self.chatConfig.systemMessageConfig.timeFormatter = self.timeFormatterGet
        self.chatConfig.systemMessageConfig.dateStampColor = self.textColor
        self.chatConfig.systemMessageConfig.dateStampFont = self.customFont.font
        
        self.chatConfig.systemMessageConfig.maxLength = 3
        
        self.chatConfig.systemMessageConfig.backgroundImage = self.image // Not working
        self.chatConfig.systemMessageConfig.borderRadius = BorderRadius(top: Corners(left: 40, right: 40 ), bottom: Corners(left: 40, right: 40 ))
        self.chatConfig.systemMessageConfig.borderRadius.top = Corners(left: 40, right: 40 )
        
    }
    
    func updateBotIncoming() {
        self.chatConfig.incomingBotConfig.backgroundColor = self.bgColor
        self.chatConfig.incomingBotConfig.textColor = self.textColor
    }
    
    func updateMultiLine() {
        self.chatConfig.multipleSelectionConfiguration.titleConfig.backgroundColor = self.bgColor
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.backgroundColor = self.bgColor
//        self.chatConfig.multipleSelectionConfiguration.backgroundColor = self.bgColor
//        self.chatConfig.multipleSelectionConfiguration.textColor = self.textColor
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



