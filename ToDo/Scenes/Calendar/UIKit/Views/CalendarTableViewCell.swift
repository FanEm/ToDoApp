//
//  CalendarTableViewCell.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import UIKit

// MARK: - CalendarTableViewCell
final class CalendarTableViewCell: UITableViewCell, ReuseIdentifying {

    // MARK: - Private properties
    private enum Constants {
        enum CardView {
            static let inset = UIEdgeInsets(top: 15, left: 25, bottom: 15, right: 25)
        }
        enum StrikeThroughView {
            static let height: CGFloat = 1
        }
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

    private let strikeThroughView: UIView = {
        let view = UIView()
        view.backgroundColor = .textTertiary
        view.isHidden = true
        return view
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
    func configureCell(todoItem: TodoItem) {
        titleLabel.text = todoItem.text
        titleLabel.textColor = todoItem.isDone ? .textTertiary : .textPrimary
        strikeThroughView.isHidden = !todoItem.isDone
        if let hex = todoItem.color {
            colorView.isHidden = false
            colorView.backgroundColor = UIColor(hex: hex)
        } else {
            colorView.isHidden = true
        }
    }

    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubviewWithoutAutoresizingMask(cardView)
        [titleLabel, colorView, strikeThroughView].forEach {
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
            strikeThroughView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            strikeThroughView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            strikeThroughView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            strikeThroughView.heightAnchor.constraint(equalToConstant: Constants.StrikeThroughView.height)
        ])
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            colorView.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor),
            colorView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor),
            colorView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            colorView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 15),
            colorView.widthAnchor.constraint(equalToConstant: 15)
        ])
    }

}
