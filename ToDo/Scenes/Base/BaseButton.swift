//
//  BaseButton.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import UIKit

// MARK: - BaseButton
class BaseButton: UIButton {

    private let font: UIFont

    // MARK: - Initializers
    init(
        icon: UIImage?,
        title: String,
        backgroundColor: UIColor,
        foregroundColor: UIColor = .textPrimary,
        horizontalAlignment: UIControl.ContentHorizontalAlignment = .center,
        font: UIFont = .todoBody
    ) {
        self.font = font
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = self.font
        config.attributedTitle = AttributedString(title, attributes: container)
        config.image = icon
        config.imagePadding = 6
        config.cornerStyle = .capsule
        config.buttonSize = .medium
        config.titleLineBreakMode = .byTruncatingTail
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25)
        configuration = config
        adjustsImageSizeForAccessibilityContentSizeCategory = true
        maximumContentSizeCategory = .accessibilityMedium
        contentHorizontalAlignment = horizontalAlignment
    }

    convenience init() {
        self.init(icon: nil, title: "", backgroundColor: .backgroundPrimary)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ title: String) {
        var container = AttributeContainer()
        container.font = self.font
        configuration?.attributedTitle = AttributedString(title, attributes: container)
    }

}
