//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import UIKit
import SwiftUI
import Combine

// MARK: - CategoryViewController
final class CategoryViewController: UIViewController {

    // MARK: - Private properties
    private let categoryView: CategoryUIView = CategoryUIView()
    private let categoryViewModel: CategoryViewModel
    private var category: Binding<Category?>?

    private var selectedIndexPath: IndexPath?
    private var cancellables = Set<AnyCancellable>()

    private lazy var addButton = UIBarButtonItem(
        image: UIImage(systemName: "plus"),
        style: .plain,
        target: self,
        action: #selector(addButtonTapped)
    )

    private lazy var closeButton = UIBarButtonItem(
        title: String(localized: "close"),
        style: .plain,
        target: self,
        action: #selector(closeButtonTapped)
    )

    // MARK: - Initializers
    init(
        category: Binding<Category?>?,
        categoryViewModel: CategoryViewModel = CategoryViewModel()
    ) {
        self.categoryViewModel = categoryViewModel
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overridden methods
    override func loadView() {
        view = categoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        setupBindings()
    }

    // MARK: - Private methods
    private func configureView() {
        categoryView.tableView.delegate = self
        categoryView.tableView.dataSource = self
    }

    private func configureNavigationBar() {
        navigationItem.title = String(localized: "category")
        navigationItem.setRightBarButton(addButton, animated: false)
        navigationItem.setLeftBarButton(closeButton, animated: false)
    }

    @objc private func addButtonTapped() {
        navigationController?.pushViewController(NewCategoryViewController(), animated: true)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

    private func setupBindings() {
        categoryViewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.categoryView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryViewModel.categoriesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryTableViewCell = tableView.dequeueReusableCell()
        let category = categoryViewModel.categoriesList[indexPath.row]
        cell.configureCell(category: category)
        if self.category?.wrappedValue == category {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            AnalyticsService.todoViewCategory(category?.wrappedValue?.id)
        }

        if selectedIndexPath == indexPath {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            category?.wrappedValue = nil
            selectedIndexPath = nil
            return
        }

        if let previouslySelectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: previouslySelectedIndexPath)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        category?.wrappedValue = categoryViewModel.categoriesList[indexPath.row]
        selectedIndexPath = indexPath
    }

}
