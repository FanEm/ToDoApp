//
//  CategoryTableViewCell.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import UIKit

// MARK: - CategoryTableViewCell
final class CategoryTableViewCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Private properties
    private enum Constants {
        enum CardView {
            static let inset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 25)
        }
        enum ColorView {
            static let size = CGSize(width: 20, height: 20)
        }
        static let spacing: CGFloat = 10
    }

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textPrimary
        label.lineBreakMode = .byTruncatingTail
        label.setFont(.todoBody)
        return label
    }()

    private let colorView = UIView()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAppearance()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overridden methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        colorView.layer.cornerRadius = 0.5 * colorView.bounds.size.width
    }

    // MARK: - Public methods
    func configureCell(category: Category) {
        titleLabel.text = category.text
        if let hex = category.color {
            colorView.isHidden = false
            colorView.backgroundColor = UIColor(hex: hex)
        } else {
            colorView.isHidden = true
        }
    }

    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubviewWithoutAutoresizingMask(cardView)
        [titleLabel, colorView].forEach {
            cardView.addSubviewWithoutAutoresizingMask($0)
        }
    }

    private func setupAppearance() {
        selectionStyle = .none
        [self, contentView, cardView].forEach { view in
            view.backgroundColor = .backgroundSecondary
        }
    }

    private func setupLayout() {
        contentView.alignSubview(cardView, with: Constants.CardView.inset)
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            colorView.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor),
            colorView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor),
            colorView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: Constants.ColorView.size.height),
            colorView.widthAnchor.constraint(equalToConstant: Constants.ColorView.size.width)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: colorView.trailingAnchor,
                constant: Constants.spacing
            ),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])
    }

}
