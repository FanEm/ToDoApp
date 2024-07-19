//
//  PersistentStorage.swift
//  ToDo
//
//  Created by Artem Novikov on 16.07.2024.
//

import Foundation
import SwiftData

// MARK: - PersistentStorage
struct PersistentStorage<T> where T: PersistentModel {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetch(predicate: Predicate<T>? = nil, sortBy: [SortDescriptor<T>] = []) throws -> [T] {
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        return try modelContext.fetch(fetchDescriptor)
    }

    func fetchCount(predicate: Predicate<T>? = nil) throws -> Int {
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
        return try modelContext.fetchCount(fetchDescriptor)
    }

    func getModel(id: PersistentIdentifier) -> T? {
        return modelContext.model(for: id) as? T
    }

    func insert(_ model: T) {
        modelContext.insert(model)
    }

    func delete(_ model: T) {
        modelContext.delete(model)
    }

}

extension PersistentStorage where T: TodoItem {

    func update(persistentModelID: PersistentIdentifier, newItem: T) {
        guard let item = getModel(id: persistentModelID) else { return }
        item.deadline = newItem.deadline
        item.text = newItem.text
        item.color = newItem.color
        item.isDone = newItem.isDone
        item.importance = newItem.importance
        item.modifiedAt = newItem.modifiedAt
    }

}
