// ===================================================================================================
// Copyright © 2025 GenesysCloud(Genesys).
// GenesysCloud SDK.
// All rights reserved.
// ===================================================================================================

import UIKit

class SnackbarView: UIView {
    private var activeSnackbarView: UIStackView?

    private let messageLabel = UILabel()
    private let settingsButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    static let shared = SnackbarView()

    private init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func show(
        topAnchorView: UIView,
        message: String,
        title: String,
        onButtonTap: @escaping () -> Void,
        onCloseTap: @escaping () -> Void
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            // Remove existing Snackbar view if any
            self.remove()

            let snackbarView = self.createSnackbarView(message: message, title: title, onButtonTap: onButtonTap, onCloseTap: onCloseTap)

            if let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first {
                keyWindow.addSubview(snackbarView)

                snackbarView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    snackbarView.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 16),
                    snackbarView.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -16),
                    snackbarView.topAnchor.constraint(equalTo: topAnchorView.topAnchor, constant: 100),
                    snackbarView.heightAnchor.constraint(equalToConstant: 48)
                ])
                self.activeSnackbarView = snackbarView
            }
        }
        
        // Remove Snackbar 10 seconds after it was displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {[weak self] in            
            self?.remove()
        }
    }

    public func remove() {
        activeSnackbarView?.removeFromSuperview()
    }

    func createSnackbarView(
        message: String,
        title: String,
        onButtonTap: @escaping () -> Void,
        onCloseTap: @escaping () -> Void
    ) -> UIStackView {
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.numberOfLines = 1

        settingsButton.setTitle(title, for: .normal)
        settingsButton.setTitleColor(.systemBlue, for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        settingsButton.addAction(UIAction(handler: { _ in onButtonTap() }), for: .touchUpInside)

        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        closeButton.addAction(UIAction(handler: { _ in onCloseTap() }), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [messageLabel, settingsButton, closeButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.backgroundColor = UIColor.systemGray5
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        return stackView
    }
}
