//
//  CalendarViewController.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import UIKit
import SwiftUI
import Combine

// MARK: - CalendarViewController
final class CalendarViewController: UIViewController {

    // MARK: - Private properties
    private let calendarView: CalendarUIView = CalendarUIView()
    private let viewModel: CalendarViewModel

    private var cancellables = Set<AnyCancellable>()
    private var isScrollingTableView = false
    private var selectedDate: IndexPath?

    private lazy var closeButton = UIBarButtonItem(
        image: UIImage(systemName: "xmark.circle.fill"),
        style: .plain,
        target: self,
        action: #selector(closeButtonTapped)
    )

    // MARK: - Initializers
    init(viewModel: CalendarViewModel = CalendarViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overridden methods
    override func loadView() {
        view = calendarView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        setupBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.openCalendar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.closeCalendar()
    }

    // MARK: - Private methods
    private func configureView() {
        calendarView.delegate = self
        calendarView.tableView.delegate = self
        calendarView.tableView.dataSource = self
        calendarView.collectionView.delegate = self
        calendarView.collectionView.dataSource = self
    }

    private func configureNavigationBar() {
        navigationItem.title = String(localized: "title")
        navigationController?.navigationBar.tintColor = .textPrimary
        navigationItem.setRightBarButton(closeButton, animated: false)
    }

    private func reloadData() {
        calendarView.collectionView.reloadData()
        let visibleIndexPaths = calendarView.tableView.indexPathsForVisibleRows ?? []
        calendarView.tableView.reloadRows(at: visibleIndexPaths, with: .none)
        guard !viewModel.data.isEmpty else { return }
        calendarView.collectionView.selectItem(
            at: selectedDate ?? IndexPath(row: 0, section: 0),
            animated: false,
            scrollPosition: .left
        )
    }

    private func dateString(for date: Date) -> String {
        switch date {
        case .distantFuture: String(localized: "calendar.other")
        default: date.dayAndMonthString
        }
    }

    private func setupBindings() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }

}

// MARK: - CalendarUIViewDelegate
extension CalendarViewController: CalendarUIViewDelegate {

    func didTapButton(_ button: UIButton) {
        AnalyticsService.calendarTapAddNew()
        let todoView = TodoView(
            viewModel: TodoViewModel(todoItem: TodoItem.empty)
        )
        let vc = UIHostingController(rootView: todoView)
        present(vc, animated: true)
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data[section].events.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.data.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: CalendarSectionHeaderView = tableView.dequeueReusableHeaderFooterView()
        headerView.configure(with: dateString(for: viewModel.data[section].date))
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CalendarTableViewCell = tableView.dequeueReusableCell()
        let todoItem = viewModel.data[indexPath.section].events[indexPath.row]
        cell.configureCell(todoItem: todoItem)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        SwipeActionsConfigurationBuilder()
            .addAction(
                style: .normal,
                title: String(localized: "done"),
                image: UIImage(systemName: "checkmark.circle.fill"),
                backgroundColor: .primaryGreen
            ) { [weak self] (_, _, completionHandler) in
                self?.viewModel.toggleDone(true, at: indexPath)
                AnalyticsService.calendarSwipeMarkAsCompleted(true)
                completionHandler(true)
            }
            .build()
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        SwipeActionsConfigurationBuilder()
            .addAction(
                style: .normal,
                title: String(localized: "undone"),
                image: UIImage(systemName: "x.circle.fill"),
                backgroundColor: .primaryRed
            ) { [weak self] (_, _, completionHandler) in
                self?.viewModel.toggleDone(false, at: indexPath)
                AnalyticsService.calendarSwipeMarkAsCompleted(false)
                completionHandler(true)
            }
            .build()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            !viewModel.data.isEmpty,
            scrollView == calendarView.tableView,
            isScrollingTableView,
            let visibleIndexPaths = calendarView.tableView.indexPathsForVisibleRows
        else { return }
        let topSectionIndex = visibleIndexPaths.first?.section ?? 0
        selectedDate = IndexPath(item: topSectionIndex, section: 0)
        calendarView.collectionView.selectItem(
            at: selectedDate,
            animated: true,
            scrollPosition: .left
        )
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == calendarView.tableView {
            isScrollingTableView = true
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == calendarView.tableView {
            isScrollingTableView = false
        }
    }

}

// MARK: - UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.data.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: CalendarCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configureCell(text: dateString(for: viewModel.data[indexPath.row].date))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPathForTableView = IndexPath(row: 0, section: indexPath.item)
        calendarView.tableView.scrollToRow(at: indexPathForTableView, at: .top, animated: true)
    }

}
