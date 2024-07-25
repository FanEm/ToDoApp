//
//  DataProvider.swift
//  ToDo
//
//  Created by Artem Novikov on 23.07.2024.
//

import SwiftData

public final class DataProvider: Sendable {

    static let shared = DataProvider()

    let sharedModelContainer: ModelContainer

    private init() {
        do {
            sharedModelContainer = try ModelContainer(for: TodoItem.self, Category.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    @MainActor var todoItemDataHandler: DataHandler<TodoItem> {
        DataHandler(modelContext: sharedModelContainer.mainContext)
    }

    @MainActor var categoryDataHandler: DataHandler<Category> {
        DataHandler(modelContext: sharedModelContainer.mainContext)
    }

}
