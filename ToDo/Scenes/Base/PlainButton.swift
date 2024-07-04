//
//  PlainButton.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import UIKit

// MARK: - PlainButton
final class PlainButton: BaseButton {

    // MARK: - Initializers
    init(
        title: String = "",
        foregroundColor: UIColor = .textPrimary,
        font: UIFont = .todoBody
    ) {
        super.init(
            icon: nil,
            title: title,
            backgroundColor: .clear,
            foregroundColor: foregroundColor,
            font: font
        )
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10,
                                                               bottom: 10, trailing: 10)
        configuration?.background.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
