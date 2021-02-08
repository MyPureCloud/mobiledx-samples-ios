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
        self.chatConfig.chatViewConfig.maxLength = 50
        self.updateLiveIncoming()
        self.updateBotIncoming()
        self.updateMultiLine()
    }
    
    func updateLiveIncoming() {
        self.chatConfig.incomingLiveConfig.backgroundColor = self.bgColor
        self.chatConfig.incomingLiveConfig.textColor = self.textColor
    }
    
    func updateBotIncoming() {
        self.chatConfig.incomingBotConfig.backgroundColor = self.bgColor
        self.chatConfig.incomingBotConfig.textColor = self.textColor
        self.updateQuickOption()
    }
    
    func updateQuickOption() {
        self.chatConfig.incomingBotConfig.quickOptionConfig.textColor = self.textColor
        self.chatConfig.incomingBotConfig.quickOptionConfig.backgroundColor = self.bgColor
    }
    
    func updateMultiLine() {
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.textColor = self.textColor
        self.chatConfig.multipleSelectionConfiguration.titleConfiguration.backgroundColor = self.bgColor
        self.chatConfig.multipleSelectionConfiguration.dateStampColor = self.dateStampColor
        self.updateMultilineItem()
//        self.chatConfig.multipleSelectionConfiguration.backgroundColor = self.bgColor
//        self.chatConfig.multipleSelectionConfiguration.textColor = self.textColor
    }
    
    func updateMultilineItem() {
        self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.backgroundColor = self.bgColor
        self.chatConfig.multipleSelectionConfiguration.persistentOptionConfiguration.textColor = self.textColor
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
    
    var dateStampColor: UIColor {
        switch self.colorType {
        case .basic:
            return UIColor.lightGray
        case .asset:
            return UIColor(named: "dateStampColor")!
        case .system:
            return UIColor.systemTeal
        }
    }
}



