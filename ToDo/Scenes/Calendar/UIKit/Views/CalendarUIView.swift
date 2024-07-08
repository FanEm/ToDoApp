//
//  CalendarUIView.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import UIKit

// MARK: - CalendarUIViewDelegate
@MainActor
protocol CalendarUIViewDelegate: AnyObject {
    func didTapButton(_ button: UIButton)
}

// MARK: - CalendarUIView
final class CalendarUIView: UIView {

    // MARK: - Public properties
    weak var delegate: CalendarUIViewDelegate?

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .backgroundPrimary
        tableView.separatorInset = .zero
        tableView.separatorColor = .primarySeparator
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 20
        tableView.contentInset.bottom = 50
        tableView.register(CalendarTableViewCell.self)
        tableView.registerReusableHeaderFooterView(CalendarSectionHeaderView.self)
        return tableView
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 75, height: 75)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .backgroundPrimary
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        collectionView.register(CalendarCollectionViewCell.self)
        return collectionView
    }()

    // MARK: - Private properties
    private enum Constants {
        static let inset: CGFloat = 5
        enum СollectionView {
            static let height: CGFloat = 90
        }
        enum FloatingButton {
            static let size = CGSize(width: 51, height: 49)
            static let bottomInset: CGFloat = 8
        }
        enum SeparatorView {
            static let height: CGFloat = 1
        }
    }

    private let separatorView = UIView()

    private let floatingButton = FloatingButton(size: Constants.FloatingButton.size)

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAppearance()
        setupLayout()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods
    private func setupViews() {
        [collectionView, tableView, separatorView, floatingButton].forEach {
            addSubviewWithoutAutoresizingMask($0)
        }
    }

    private func setupAppearance() {
        backgroundColor = .backgroundPrimary
        separatorView.backgroundColor = .primarySeparator
    }

    private func setupTargets() {
        floatingButton.addTarget(self, action: #selector(tapOnButton(_:)), for: .touchUpInside)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.СollectionView.height),
            collectionView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: Constants.inset
            )
        ])
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.SeparatorView.height),
            separatorView.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor,
                constant: Constants.inset
            )
        ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.inset),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            floatingButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            floatingButton.heightAnchor.constraint(equalToConstant: Constants.FloatingButton.size.height),
            floatingButton.widthAnchor.constraint(equalToConstant: Constants.FloatingButton.size.width),
            floatingButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.FloatingButton.bottomInset
            )
        ])
    }

}

// MARK: - Delegate
extension CalendarUIView {

    @objc private func tapOnButton(_ sender: UIButton) {
        delegate?.didTapButton(sender)
    }

}
