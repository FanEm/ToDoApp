//
//  CategoryViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 04.07.2024.
//

import SwiftUI
import Combine
import SwiftData

// MARK: - CategoryViewModel
@MainActor
final class CategoryViewModel: ObservableObject {

    @Published var categories: [Category] = []

    private let categoryDataHandler: DataHandler<Category>

    init(dataProvider: DataProvider = DataProvider.shared) {
        self.categoryDataHandler = dataProvider.categoryDataHandler
        self.addDefaultCategoriesIfNeeded()
    }

    func fetch() {
        do {
            categories = try categoryDataHandler.fetch(
                sortBy: [.init(\.createdAt)]
            )
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    private func addDefaultCategoriesIfNeeded() {
        guard !StorageService.shared.defaultCategoriesAdded else { return }
        for category in GlobalConstants.defaultCategories {
            categoryDataHandler.insert(category)
        }
        StorageService.shared.defaultCategoriesAdded = true
    }

}
