//
//  ChatConfigurationHandler.swift
//  BasicSample
//
//  Created by Omer Rahmany on 16/08/2020.
//  Copyright © 2020 bold360ai. All rights reserved.
//

import UIKit
import Bold360AI

class ChatConfigurationHandler: NSObject {
    
    private var customFont:CustomFont
    
    override init() {
        customFont = CustomFont()
    }
    
    var defaultConfig: Bold360AI.ChatConfiguration {
        get {
            return Bold360AI.ChatConfiguration()
        }
    }
    
    
    var test:Bold360AI.ChatConfiguration {
        get {
            let config = Bold360AI.ChatConfiguration()
//            config.chatViewConfig.backgroundColor = UIColor.gray
//            config.chatViewConfig.backgroundImage = UIImage(named: "bold")
//            config.chatViewConfig.dateStampColor = UIColor.red
//            config.chatViewConfig.customFont = customFont
//            // TODO:: make sure it works
//            config.chatViewConfig.maxLength = 5

            // Nisso
//            config.chatViewConfig.avatarImageSize = .large
            // Viktor
//            config.chatViewConfig.avatarImageWidthSize = 30.0
//            config.chatViewConfig.avatarImageHightSize = 30.0

//            config.incomingBotConfig.quickOptionConfig.avatarPosition = AvatarPosition.topLeft
//
//            config.incomingBotConfig.quickOptionConfig.avatar = UIImage(named: "robot")
//
//
//            config.incomingBotConfig.quickOptionConfig.textColor = UIColor.red
//            let dateFormatterGet = DateFormatter()
//            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            config.incomingBotConfig.quickOptionConfig.dateFormatter = dateFormatterGet
//            let timeFormatterGet = DateFormatter()
//            timeFormatterGet.dateFormat = "HH:mm:ss"
//            config.incomingBotConfig.quickOptionConfig.timeFormatter = timeFormatterGet
//
//            // IncomingBotConfiguration
//
//            // IncomingBotConfiguration : ChatElementConfiguration
            config.incomingBotConfig.backgroundColor = UIColor(named: "incomingTest")
//            config.incomingBotConfig.backgroundImage = UIImage(named: "bold")
//            config.incomingBotConfig.dateStampColor = UIColor.systemGreen
//            config.incomingBotConfig.dateStampFont = UIFont.italicSystemFont(ofSize: 30)
            customFont.font = UIFont.italicSystemFont(ofSize: 30)
            config.incomingBotConfig.customFont = customFont
//            config.incomingBotConfig.maxLength = 3
            
//            config.incomingBotConfig.avatarPosition = AvatarPosition.bottomRight
//            config.incomingBotConfig.avatar = UIImage(named: "agent")
            config.incomingBotConfig.textColor = UIColor.red
//            config.incomingBotConfig.dateFormatter = dateFormatterGet
//            config.incomingBotConfig.timeFormatter = timeFormatterGet

//
//            // IncomingBotConfiguration - QuickOptionConfiguration *quickOptionConfig
//            // QuickOptionConfiguration : ChatElementConfiguration
//            config.incomingBotConfig.quickOptionConfig.backgroundColor = UIColor.purple
//            config.incomingBotConfig.quickOptionConfig.backgroundImage = UIImage(named: "bold")
//            config.incomingBotConfig.quickOptionConfig.dateStampColor = UIColor.brown
//            config.incomingBotConfig.quickOptionConfig.customFont = customFont
//            config.incomingBotConfig.quickOptionConfig.maxLength = 2
//
//            // IncomingBotConfiguration - PersistentOptionConfiguration *persistentOptionConfig
//            // PersistentOptionConfiguration : ChatElementConfiguration
//            config.incomingBotConfig.persistentOptionConfig.backgroundImage = UIImage(named: "bold")
//
//            // IncomingBotConfiguration - InstantFeedbackConfiguration *instantFeedbackConfig
//            // IncomingBotTitleConfiguration : ChatElementConfiguration
//            // TODO:: check if the inheritence is wrong
//            config.incomingBotConfig.titleConfig.backgroundColor = UIColor.blue
//            config.incomingBotConfig.titleConfig.backgroundImage = UIImage(named: "bold")
//            config.incomingBotConfig.titleConfig.dateStampColor = UIColor.darkGray
//            config.incomingBotConfig.titleConfig.customFont = customFont
//            config.incomingBotConfig.titleConfig.maxLength = 3
//
//            // IncomingBotConfiguration - CarouselConfiguration *carouselConfig
//            // CarouselConfiguration : ChatElementConfiguration
//            config.incomingBotConfig.carouselConfig.backgroundColor = UIColor.yellow
//            config.incomingBotConfig.carouselConfig.backgroundImage = UIImage(named: "bold")
//            config.incomingBotConfig.carouselConfig.dateStampColor = UIColor.black
//            config.incomingBotConfig.carouselConfig.customFont = customFont
//            config.incomingBotConfig.carouselConfig.maxLength = 4
//
//            // CarouselButtonConfiguration : ChatElementConfiguration
//            config.incomingBotConfig.carouselConfig.button.backgroundColor = UIColor.blue
//            config.incomingBotConfig.carouselConfig.button.backgroundImage = UIImage(named: "bold")
//            config.incomingBotConfig.carouselConfig.button.dateStampColor = UIColor.darkGray
//            config.incomingBotConfig.carouselConfig.button.customFont = customFont
//            config.incomingBotConfig.carouselConfig.button.maxLength = 3
//
//            // OutgoingConfiguration
//            config.outgoingConfig.sentSuccessfullyIcon = UIImage(named: "bold")
//            config.outgoingConfig.sentFailureIcon = UIImage(named: "bold")
//            config.outgoingConfig.pendingIcon = UIImage(named: "bold")
//
//            // OutgoingConfiguration : ChatElementConfiguration
            config.outgoingConfig.backgroundColor = UIColor.blue
//            config.outgoingConfig.backgroundImage = UIImage(named: "bold")
//            config.outgoingConfig.dateStampColor = UIColor.red
//            config.outgoingConfig.dateStampFont = UIFont(name: "Times New Roman", size: 13.0)//            config.outgoingConfig.customFont = customFont
//            config.outgoingConfig.maxLength = 3
//            
//            config.outgoingConfig.avatarPosition = AvatarPosition.bottomRight
//            config.outgoingConfig.avatar = UIImage(named: "agent")
            config.outgoingConfig.textColor = UIColor.green
//            config.outgoingConfig.dateFormatter = dateFormatterGet
//            config.outgoingConfig.timeFormatter = timeFormatterGet

//
//            // SystemMessageConfiguration
//            // SystemMessageConfiguration : ChatElementConfiguration
//            config.systemMessageConfig.backgroundColor = UIColor.blue
//            config.systemMessageConfig.backgroundImage = UIImage(named: "bold")
//            config.systemMessageConfig.dateStampColor = UIColor.darkGray
//            config.systemMessageConfig.customFont = customFont
//            config.systemMessageConfig.maxLength = 3
//
//            // InfoViewConfiguration
//            config.queueViewConfig.textColor = UIColor.blue
//            config.queueViewConfig.backgroundColor = UIColor.blue
//            config.queueViewConfig.font = UIFont.systemFont(ofSize: 12)
//
//            // SearchViewConfiguration
//            config.searchViewConfig.speechOnIcon = UIImage(named: "bold")
//            config.searchViewConfig.speechOffIcon = UIImage(named: "bold")
//            config.searchViewConfig.readoutIcon = UIImage(named: "bold")
//            config.searchViewConfig.sendIcon = UIImage(named: "bold")
//            config.searchViewConfig.uploadIcon = UIImage(named: "bold")
//            config.searchViewConfig.voiceEnabled = false
//            config.searchViewConfig.languageCode = "heb"
//            // AutoCompleteConfiguration * autoCompleteConfiguration
//            config.searchViewConfig.autoCompleteConfiguration?.isEnabled = true
//            // AutoCompleteConfiguration : TextConfiguration
//            config.searchViewConfig.autoCompleteConfiguration?.text = "Hey"
//            config.searchViewConfig.autoCompleteConfiguration?.font  = UIFont.systemFont(ofSize: 20)
//            config.searchViewConfig.autoCompleteConfiguration?.backgroundColor = UIColor.red
//            config.searchViewConfig.autoCompleteConfiguration?.textColor = UIColor.blue
//            // PlaceholderConfiguration * placeholderConfiguration
//            config.searchViewConfig.placeholderConfiguration?.recordText = "Recording Now.."
//            config.searchViewConfig.placeholderConfiguration?.readoutext = "Readingout Now.."
//            // PlaceholderConfiguration : TextConfiguration
//            config.searchViewConfig.placeholderConfiguration?.text = "Placeholder text"
//            config.searchViewConfig.placeholderConfiguration?.font  = UIFont.systemFont(ofSize: 20)
//            config.searchViewConfig.placeholderConfiguration?.backgroundColor = UIColor.red
//            config.searchViewConfig.placeholderConfiguration?.textColor = UIColor.blue
//            // SearchViewConfiguration : TextConfiguration
//            config.searchViewConfig.text = "hey"
//            config.searchViewConfig.font = customFont.font
//            config.searchViewConfig.textColor = UIColor.green
//            config.searchViewConfig.backgroundColor = UIColor.purple
//
//            // ReadMoreViewConfiguration
//            // ReadMoreTitleConfiguration *title
//            // ReadMoreTitleConfiguration : AutoCompleteConfiguration
//            config.readMoreViewConfig.title.isEnabled = false
//            config.readMoreViewConfig.title.text = "hey"
            config.readMoreViewConfig.title.customFont = customFont
            config.readMoreViewConfig.title.textColor = UIColor.green
            config.readMoreViewConfig.title.backgroundColor = UIColor.purple
//
//            // ChatBarConfiguration
//            config.chatBarConfiguration.image = UIImage(named: "bold")!
//            config.chatBarConfiguration.agentName = "agent name"
//            config.chatBarConfiguration.endChatBtnTitle = "endChatBtnTitle"
//            config.chatBarConfiguration.endChatBtnTextColor = UIColor.green
//            config.chatBarConfiguration.endChatButtonEnabled = true
//            config.chatBarConfiguration.enabled = true
//
//            // ChatBarConfiguration : InfoViewConfiguration
//            config.chatBarConfiguration.textColor = UIColor.green
//            config.chatBarConfiguration.backgroundColor = UIColor.brown
//            config.chatBarConfiguration.font = customFont.font
//
//            // VoiceToVoiceConfiguration
//            config.voiceToVoiceConfiguration.type = .default
//            config.voiceToVoiceConfiguration.silenceTimeBeforeMessageSent = 3.0
//            // SynthesizerConfiguration *synthesizerConfiguration
//            config.voiceToVoiceConfiguration.synthesizerConfiguration.currentLanguageCode = "en-GB"
//            config.voiceToVoiceConfiguration.synthesizerConfiguration.pitchMultiplier = 2.0
//            config.voiceToVoiceConfiguration.synthesizerConfiguration.preUtteranceDelay = 2.0
//            config.voiceToVoiceConfiguration.synthesizerConfiguration.rate = 2.0
//            config.voiceToVoiceConfiguration.synthesizerConfiguration.volume = 0.5
//
//            // BoldFormConfiguration
//            // BoldFormElementConfiguration *titleConfig
//            // BoldFormElementConfiguration
//            config.formConfiguration.titleConfig.font = customFont.font
//            config.formConfiguration.titleConfig.textColor = UIColor.green
//            config.formConfiguration.titleConfig.backgroundColor = UIColor.blue
//
//            config.formConfiguration.multiSelectElementConfig.font = customFont.font
//            config.formConfiguration.multiSelectElementConfig.textColor = UIColor.green
//            config.formConfiguration.multiSelectElementConfig.backgroundColor = UIColor.blue

            return config
        }
    }
}
