//
//  CalendarCollectionViewCell.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import UIKit

// MARK: - CalendarCollectionViewCell
final class CalendarCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Private properties
    private enum Constants {
        enum TitleLabel {
            static let inset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .textSecondary
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.setFont(.font(textStyle: .footnote, maximumPointSize: .extraExtraLarge))
        return label
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundPrimary
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.primarySeparator.cgColor
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAppearance()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overridden methods
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            cardView.layer.borderColor = UIColor.primarySeparator.cgColor
        }
    }

    override var isSelected: Bool {
        didSet {
            setupSelectedStyle(isSelected)
        }
    }

    // MARK: - Public methods
    func configureCell(text: String) {
        titleLabel.setAttributedText(text.replacingOccurrences(of: " ", with: "\n"), lineSpacing: 10)
    }

    // MARK: - Private methods
    private func setupViews() {
        contentView.addSubviewWithoutAutoresizingMask(cardView)
        cardView.addSubviewWithoutAutoresizingMask(titleLabel)
    }

    private func setupAppearance() {
        [self, contentView].forEach { $0.backgroundColor = .backgroundPrimary }
    }

    private func setupLayout() {
        contentView.alignSubview(cardView)
        cardView.alignSubview(titleLabel, with: Constants.TitleLabel.inset)
    }

    private func setupSelectedStyle(_ isSelected: Bool) {
        cardView.layer.borderWidth = isSelected ? 1 : 0
        cardView.backgroundColor =  isSelected ? .backgroundSecondary : .backgroundPrimary
    }

}

// MARK: - UILabel
private extension UILabel {

    func setAttributedText(_ text: String, lineSpacing: CGFloat = 10) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attributedText = NSMutableAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
    }

}
