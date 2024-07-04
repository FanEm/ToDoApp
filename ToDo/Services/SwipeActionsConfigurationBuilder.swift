//
//  SwipeActionsConfigurationBuilder.swift
//  ToDo
//
//  Created by Artem Novikov on 02.07.2024.
//

import UIKit

final class SwipeActionsConfigurationBuilder {

    private var actions: [UIContextualAction] = []

    func addAction(
        style: UIContextualAction.Style,
        title: String,
        image: UIImage?,
        backgroundColor: UIColor?,
        handler: @escaping (UIContextualAction, UIView, @escaping (Bool) -> Void) -> Void
    ) -> SwipeActionsConfigurationBuilder {
        let action = UIContextualAction(style: style, title: title, handler: handler)
        action.backgroundColor = backgroundColor
        action.image = image
        actions.append(action)
        return self
    }

    func build() -> UISwipeActionsConfiguration {
        UISwipeActionsConfiguration(actions: actions)
    }

}
