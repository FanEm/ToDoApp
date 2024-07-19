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
final class CategoryViewModel: ObservableObject {

    @Published var categories: [Category] = []

    private let persistentStorage: PersistentStorage<Category>

    init(modelContext: ModelContext) {
        self.persistentStorage = PersistentStorage(modelContext: modelContext)
        self.addDefaultCategoriesIfNeeded()
    }

    func fetch() {
        do {
            categories = try persistentStorage.fetch(
                sortBy: [.init(\.createdAt)]
            )
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    private func addDefaultCategoriesIfNeeded() {
        guard !StorageService.shared.defaultCategoriesAdded else { return }
        for category in GlobalConstants.defaultCategories {
            persistentStorage.insert(category)
        }
        StorageService.shared.defaultCategoriesAdded = true
    }

}
