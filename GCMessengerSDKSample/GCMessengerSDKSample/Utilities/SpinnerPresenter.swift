//
//  SpinnerPresenter.swift
//  GCMessengerSDKSample
//
//  Created by Levente Anda on 2026. 03. 25..
//

import UIKit

@MainActor
final class SpinnerPresenter {
    private let activityView = UIActivityIndicatorView(style: .large)
    private var constraints: [NSLayoutConstraint] = []

    func attach(to view: UIView) {
        activityView.layer.backgroundColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        activityView.center = view.center
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityView)
    }

    private func setConstraints() {
        guard let superview = activityView.superview else { return }
        removeConstraints()

        constraints = [
            activityView.topAnchor.constraint(equalTo: superview.topAnchor),
            activityView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            activityView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            activityView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func removeConstraints() {
        NSLayoutConstraint.deactivate(constraints)
        constraints.removeAll()
    }

    func start() {
        setConstraints()
        activityView.startAnimating()
    }

    func stop() {
        activityView.stopAnimating()
        removeConstraints()
    }
}
