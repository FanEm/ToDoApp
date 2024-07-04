//
//  CategoryUIView.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import UIKit

// MARK: - CategoryUIView
final class CategoryUIView: UIView {

    // MARK: - Public properties
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .backgroundPrimary
        tableView.separatorInset.left = 45
        tableView.separatorColor = .primarySeparator
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(CategoryTableViewCell.self)
        return tableView
    }()

    // MARK: - Private properties
    private enum Constants {
        static let inset: CGFloat = 5
    }

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

    // MARK: - Private methods
    private func setupViews() {
        addSubviewWithoutAutoresizingMask(tableView)
    }

    private func setupAppearance() {
        backgroundColor = .backgroundPrimary
    }

    private func setupLayout() {
        alignSubview(tableView)
    }

}
