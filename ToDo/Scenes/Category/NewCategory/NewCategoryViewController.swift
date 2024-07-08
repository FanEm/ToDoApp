//
//  NewCategoryViewController.swift
//  ToDo
//
//  Created by Artem Novikov on 03.07.2024.
//

import UIKit
import SwiftUI
import Combine

// MARK: - NewCategoryViewController
final class NewCategoryViewController: BaseScrollableViewController {

    // MARK: - Private properties
    @ObservedObject private var viewModel: NewCategoryViewModel
    private let newCategoryView: NewCategoryUIView = NewCategoryUIView()
    private var cancellables = Set<AnyCancellable>()

    private lazy var saveButton = UIBarButtonItem(
        title: String(localized: "save"),
        style: .done,
        target: self,
        action: #selector(saveButtonTapped)
    )

    private lazy var backButton = UIBarButtonItem(
        image: UIImage(systemName: "chevron.left"),
        style: .plain,
        target: self,
        action: #selector(backButtonTapped)
    )

    // MARK: - Initializers
    init(viewModel: NewCategoryViewModel = NewCategoryViewModel()) {
        self.viewModel = viewModel
        super.init(baseScrollableView: newCategoryView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overridden methods
    override func loadView() {
        view = newCategoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        hideKeyboardWhenTappedAround()
        setupBindings()
    }

    // MARK: - Private methods
    private func configureView() {
        newCategoryView.delegate = self
        let swiftUIView = CustomColorPicker(selectedColor: $viewModel.selectedColor)
        let hostingController = UIHostingController(rootView: swiftUIView)
        addChild(hostingController)
        newCategoryView.addColorPickerAndLayout(hostingController.view)
        hostingController.didMove(toParent: self)
    }

    private func configureNavigationBar() {
        navigationItem.title = String(localized: "category.new")
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationItem.setLeftBarButton(backButton, animated: false)
    }

    private func setupBindings() {
        viewModel.$canItemBeSaved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.saveButton.isEnabled = newValue
            }
            .store(in: &cancellables)
    }

    @objc private func saveButtonTapped() {
        viewModel.saveItem()
        saveButton.isEnabled = false
        navigationController?.popViewController(animated: true)
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - NewCategoryUIViewDelegate
extension NewCategoryViewController: NewCategoryUIViewDelegate {

    func didChangeTextField(text: String) {
        viewModel.text = text
    }

}
