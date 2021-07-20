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
    
    lazy var chatConfig = { () -> Bold360AI.ChatConfiguration in
        var config = Bold360AI.ChatConfiguration()
//        self.colorType = .basic
        return config
    }()
    
    func updateConfig() {
        self.updateLiveIncoming()
        self.updateChatViewConfig()
        self.updateOutgoingConfig()
        self.updateBotIncoming()
        self.updateMultiLine()
        self.updateSearchBar()
    }
    
    func updateOutgoingConfig() {
        self.chatConfig.outgoingConfig.checkOutgoing()
    }
    
    func updateChatViewConfig() {
        self.chatConfig.chatViewConfig.hyperlinkColor = UIColor.red
        self.chatConfig.chatViewConfig.avatarSize = CGSize(width: 50.0, height: 50.0)
        let dateStamp = DateStampConfiguration()
        dateStamp.formatter = DateFormatter()
        dateStamp.formatter.dateFormat = "MMM dd,yyyy"
        dateStamp.customFont = CustomFont(font: UIFont.boldSystemFont(ofSize: 12))
        dateStamp.textColor = UIColor.black
        let timeStamp = DateStampConfiguration()
        timeStamp.formatter = DateFormatter()
        timeStamp.formatter.dateFormat = "HH:mm"
        timeStamp.customFont = CustomFont(font: UIFont.boldSystemFont(ofSize: 8))
        timeStamp.textColor = self.colorType.dateStampColor
        self.chatConfig.chatViewConfig.dateStamp = dateStamp
        self.chatConfig.chatViewConfig.timeStamp = timeStamp
    }
    
    func updateLiveIncoming() {
        self.chatConfig.incomingLiveConfig.checkIncoming(self.colorType)
    }
    
    func updateBotIncoming() {
        self.chatConfig.incomingBotConfig.checkIncoming(self.colorType)
        updateQuickOption()
    }
    
    
    func updateSearchBar() {
        self.chatConfig.searchViewConfig.backgroundColor = self.colorType.bgColor
        self.chatConfig.searchViewConfig.textColor = self.colorType.textColor
        self.chatConfig.searchViewConfig.speechOnIcon = UIImage(named: "restore")
        self.chatConfig.searchViewConfig.speechOffIcon = UIImage(named: "search")
        self.chatConfig.searchViewConfig.sendIcon = UIImage(named: "history")
        let border = Border()
        border.width = 1
        border.color = UIColor.red
        border.cornerRadius = 5
        self.chatConfig.searchViewConfig.border = border
        self.chatConfig.searchViewConfig.autoCompleteConfiguration?.backgroundColor = self.colorType.bgColor
        self.chatConfig.searchViewConfig.autoCompleteConfiguration?.textColor = self.colorType.textColor
        self.chatConfig.searchViewConfig.autoCompleteConfiguration?.customFont = CustomFont(font: UIFont.systemFont(ofSize: 20))
        self.chatConfig.searchViewConfig.placeholderConfiguration?.customFont = CustomFont(font: UIFont.systemFont(ofSize: 10))
    }
    
    
    
    func updateQuickOption() {
        self.chatConfig.incomingBotConfig.quickOptionConfig.checkCorners(self.colorType)
    }
    
    func updateMultiLine() {
        self.chatConfig.multipleSelectionConfiguration.checkMessage(self.colorType)
        self.chatConfig.multipleSelectionConfiguration.borderRadius = BorderRadius(top: Corners(left: 0, right: 0 ), bottom: Corners(left: 0, right: 0 ))
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.textColor = self.colorType.bgColor
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.backgroundColor = UIColor.green
        self.updateMultilineItem()
    }
    
    func updateMultilineItem() {
        if #available(iOS 13.0, *) {
            self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
        }
        self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.textColor = self.colorType.textColor
        self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.customFont = CustomFont(font: UIFont(name: "Times New Roman", size: 9.0)!)
    }
    
    
}


extension ColorType {
    var bgColor: UIColor {
        switch self {
        case .basic:
            return UIColor.red
        case .asset:
            return UIColor(named: "bgColor")!
        case .system:
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground
            } else {
                // Fallback on earlier versions
                return UIColor.systemGreen

            }
        }
        
    }
    
    var textColor: UIColor {
        switch self {
        case .basic:
            return UIColor.blue
        case .asset:
            return UIColor(named: "textColor")!
        case .system:
            if #available(iOS 13.0, *) {
                return UIColor.label
            } else {
                // Fallback on earlier versions
                return UIColor.systemBlue
            }
        }
    }
    
    var dateStampColor: UIColor {
        switch self {
        case .basic:
            return UIColor.lightGray
        case .asset:
            return UIColor(named: "dateStampColor")!
        case .system:
            return UIColor.systemTeal
        }
    }
}



extension CommonConfig {
    func checkCommon(_ colorType: ColorType) {
        self.backgroundColor = colorType.bgColor
        self.textColor = colorType.textColor
        self.customFont = CustomFont(font: UIFont.italicSystemFont(ofSize: 20))
    }
}

// MARK: extends CommonConfig
extension FullCornersItemConfiguration {
    func checkCorners(_ colorType: ColorType) {
        self.checkCommon(colorType)
        self.borderRadius = BorderRadius(top: Corners(left: 5, right: 5), bottom: Corners(left: 0, right: 0))
    }
}


// MARK: extends FullCornersItemConfiguration
extension MessageConfiguration {
    func checkMessage(_ colorType: ColorType) {
        self.checkCorners(colorType)
        self.avatrImageName = "bold"
    }
}

// MARK: extends MessageConfiguration
extension IncomingMessageConfiguration {
    func checkIncoming(_ colorType: ColorType) {
        self.checkMessage(colorType)
        self.maxLength = 100
    }
}

// MARK: extends MessageConfiguration
extension OutgoingConfiguration {
    func checkOutgoing() {
        self.checkMessage(.basic)
        self.avatrImageName = "robot"
        if #available(iOS 13.0, *) {
            self.pendingIcon = UIImage(systemName: "shuffle")
            self.sentFailureIcon = UIImage(systemName: "prohibit")
            self.sentSuccessfullyIcon = UIImage(named: "invitation")
        } else {
            // Fallback on earlier versions
        }
        
    }
}

