//
//  TextFieldWithInset.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import UIKit

// MARK: - TextFieldWithInset
final class TextFieldWithInset: UITextField {

    private enum Constants {
        static let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.padding)
    }

}
