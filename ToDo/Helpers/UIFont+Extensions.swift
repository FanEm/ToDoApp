//
//  UIFont+Extensions.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import UIKit

extension UIFont {

    static func font(
        textStyle: UIFont.TextStyle,
        defaultSize: CGFloat? = nil,
        maximumPointSize: UIContentSizeCategory = .accessibilityExtraExtraExtraLarge
    ) -> UIFont {
        let size = defaultSize ?? UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle).pointSize
        let fontToScale: UIFont = .systemFont(ofSize: size)
        return textStyle.metrics.scaledFont(
            for: fontToScale,
            maximumPointSize: UIFont.preferredFont(
                forTextStyle: textStyle,
                compatibleWith: UITraitCollection(
                    preferredContentSizeCategory: maximumPointSize
                )
            ).pointSize
        )
    }

    static var todoLargeTitle: UIFont {
        font(textStyle: .largeTitle)
    }

    static var todoTitle: UIFont {
        font(textStyle: .title2)
    }

    static var todoHeadline: UIFont {
        font(textStyle: .headline)
    }

    static var todoBody: UIFont {
        font(textStyle: .body)
    }

    static var todoSubhead: UIFont {
        font(textStyle: .subheadline)
    }

    static var todoFootnote: UIFont {
        font(textStyle: .footnote)
    }

}
