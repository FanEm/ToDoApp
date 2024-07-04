//
//  CalendarSectionHeaderView.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import UIKit

// MARK: - CalendarSectionHeaderView
final class CalendarSectionHeaderView: UITableViewHeaderFooterView, ReuseIdentifying {

    // MARK: - Private Properties
    private enum Constants {
        enum TitleLabel {
            static let inset = UIEdgeInsets(top: 5, left: 25, bottom: 15, right: 25)
        }
    }

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setFont(.todoBody)
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .textSecondary
        return label
    }()

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configure(with title: String) {
        titleLabel.text = title
    }

    // MARK: - Private Methods
    private func setupViews() {
        contentView.backgroundColor = .backgroundPrimary
        contentView.addSubviewWithoutAutoresizingMask(titleLabel)
    }

    private func setupLayout() {
        contentView.alignSubview(titleLabel, with: Constants.TitleLabel.inset)
    }

}
