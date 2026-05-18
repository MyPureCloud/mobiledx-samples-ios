//
//  ToastView.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 03..
//

import UIKit

class ToastView: UILabel {
    init(message: String, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) {
        super.init(frame: .zero)

        self.accessibilityIdentifier = "toast_view"
        self.accessibilityLabel = message
        self.backgroundColor = backgroundColor ?? .gray
        self.textColor = textColor ?? .black
        self.textAlignment = .center
        self.font = UIFont.preferredFont(forTextStyle: .caption1)
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.text = message
        self.numberOfLines = 0
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
