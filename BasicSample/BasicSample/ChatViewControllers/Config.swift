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
    
    lazy var chatConfig = {
        Bold360AI.ChatConfiguration()
    }()
    
    func updateConfig() {
        self.image = UIImage(named: "agent")!
        self.customFont.font = UIFont.italicSystemFont(ofSize: 30)
        self.dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.updateChatView()
        self.updateBotIncoming()
        self.updateLiveIncoming()
        self.updateMultiLine()
        self.updateOutgoing()
        self.updateSystemMessage()
    }
    
    func updateChatView() {
        self.chatConfig.chatViewConfig.backgroundColor = self.bgColor
        self.chatConfig.chatViewConfig.backgroundImage = self.image
        
        updateDateStamp(datestampConfig: self.chatConfig.chatViewConfig.dateStamp)
        updateDateStamp(datestampConfig: self.chatConfig.chatViewConfig.timeStamp)
    }
    
    func updateBotIncoming() {
        self.chatConfig.incomingBotConfig.maxLength = 10
        updateMessageConfiguration(messageConfiguration: self.chatConfig.incomingBotConfig!)
        
        self.updateQuickOptions()
    }
    
    
    func updateSystemMessage() {
        updateFullCornersItemConfiguration(fullCornerItemConfiguration: self.chatConfig.systemMessageConfig)
    }
    
    func updateOutgoing() {
        self.chatConfig.outgoingConfig.sentFailureIcon = self.image
        self.chatConfig.outgoingConfig.sentSuccessfullyIcon = self.image
        self.chatConfig.outgoingConfig.pendingIcon = self.image
        updateMessageConfiguration(messageConfiguration: self.chatConfig.outgoingConfig)
    }
    
    func updateLiveIncoming() {
        updateMessageConfiguration(messageConfiguration: self.chatConfig.incomingLiveConfig)
    }
    
    func updateMultiLine() {
        updateMessageConfiguration(messageConfiguration: self.chatConfig.multipleSelectionConfiguration!)
        
        updatePersistentOptionsTitle()
        updatePersistentOptions()
    }
    
    func updatePersistentOptionsTitle() {
        updatePartialCornerItemConfiguration(partialCornerItemConfiguration: self.chatConfig.multipleSelectionConfiguration.titleConfiguration)
    }
    
    func updatePersistentOptions() {
        updatePartialCornerItemConfiguration(partialCornerItemConfiguration: self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration)
    }
    
    func updateQuickOptions() {
        updateFullCornersItemConfiguration(fullCornerItemConfiguration: self.chatConfig.incomingBotConfig.quickOptionConfig)
    }
    
    func updateDateStamp(datestampConfig:DateStampConfiguration) {
        datestampConfig.formatter = self.dateFormatterGet
        datestampConfig.textColor = self.textColor
//        datestampConfig.customFont = self.customFont
    }
    
    func updateCommonConfig(commonConfig: CommonConfig) {
        commonConfig.backgroundColor = self.bgColor
        commonConfig.textColor = self.textColor
        commonConfig.customFont = self.customFont
        commonConfig.backgroundImage = self.image
    }
    
    func updateMessageConfiguration(messageConfiguration: MessageConfiguration) {
        self.updateFullCornersItemConfiguration(fullCornerItemConfiguration: messageConfiguration)
        messageConfiguration.avatar = self.image
        messageConfiguration.avatarPosition = AvatarPosition.topRight
      }
    
    func updateFullCornersItemConfiguration(fullCornerItemConfiguration:FullCornersItemConfiguration) {
        updateCommonConfig(commonConfig: fullCornerItemConfiguration)
        fullCornerItemConfiguration.borderRadius = BorderRadius(top: Corners(left: 0, right: 70 ), bottom: Corners(left: 40, right: 70 ))
    }
    
    func updatePartialCornerItemConfiguration(partialCornerItemConfiguration:PartialCornerItemConfiguration){
        self.updateCommonConfig(commonConfig: partialCornerItemConfiguration)
        partialCornerItemConfiguration.cornersRadius = Corners(left: 0, right: 70 )
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



