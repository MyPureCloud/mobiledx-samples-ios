//
//  OptionButton.swift
//  BoldDemo
//
//  Created by Nissim Pardo on 21/02/2019.
//  Copyright © 2019 bold360ai. All rights reserved.
//

import UIKit

class OptionButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }
    
    override var isEnabled: Bool {
        didSet {            if !self.isEnabled {
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.setTitleColor(UIColor.lightGray, for: .normal)
            } else {
                self.layer.borderColor = self.tintColor.cgColor
                self.setTitleColor(self.tintColor, for: .normal)
            }
        }
    }
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        super.sendAction(action, to: target, for: event)
        //self.backgroundColor = self.tintColor
        //self.setTitleColor(UIColor.white, for: .normal)
        //self.perform(#selector(OptionButton.changeToDefault), with: nil, afterDelay: 0.2)
    }
    
    override var tintColor: UIColor! {
        didSet {
            self.layer.borderColor = self.tintColor.cgColor
        }
    }
    
    func initializeUI() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.borderWidth = 1
    }
    
    @objc func changeToDefault() {
        self.setTitleColor(self.tintColor, for: .normal)
        self.backgroundColor = UIColor.white
    }

}
