//
//  FloatingButton.swift
//  ToDo
//
//  Created by Artem Novikov on 02.07.2024.
//

import UIKit

// MARK: - FloatingButton
final class FloatingButton: UIButton {

    init(size: CGSize) {
        super.init(frame: .zero)
        let config = UIImage.SymbolConfiguration(paletteColors: [.primaryWhite, .primaryBlue])
            .applying(UIImage.SymbolConfiguration(pointSize: size.width, weight: .regular, scale: .default))
        setImage(UIImage(systemName: "plus.circle.fill")?.withConfiguration(config), for: .normal)
        layer.cornerRadius = size.width/2
        layer.shadowColor = UIColor.buttonShadow.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = .init(width: 0, height: 8)
        layer.shadowOpacity = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
