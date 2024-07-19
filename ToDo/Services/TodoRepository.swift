//
//  TodoRepository.swift
//  ToDo
//
//  Created by Artem Novikov on 17.07.2024.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

// MARK: - TodoRepository
@MainActor
final class TodoRepository: ObservableObject {

    // MARK: - Public properties
    @Published private(set) var activeRequestsCount = 0
    enum TodoRepositoryError: Error {
        case notFound
    }

    // MARK: - Private properties
    private var todoNetworkService: TodoNetworkService
    private let persistentStorage: PersistentStorage<TodoItem>
    private var cancellables = Set<AnyCancellable>()
    private var revision: Int {
        StorageService.shared.revision
    }

    // MARK: - Initializers
    init(
        todoNetworkService: TodoNetworkService = TodoNetworkService.shared,
        persistentStorage: PersistentStorage<TodoItem>
    ) {
        self.todoNetworkService = todoNetworkService
        self.persistentStorage = persistentStorage
        setupBindings()
    }

    // MARK: - Public methods
    func syncWithServer() async throws {
        let response = try await todoNetworkService.fetchTodoList()
        let serverTodoItems = response.list.map { $0.toModel }
        let localTodoItems = try fetchTodoListFromPersistentStorage()
        deleteLocalItemsNotInServerList(localItems: localTodoItems, serverItems: serverTodoItems)
        let updatedLocalTodoItems = try fetchTodoListFromPersistentStorage()
        saveTodoItemsToPersistentStorage(localItems: updatedLocalTodoItems, serverItems: serverTodoItems)
    }

    func fetchTodoList(
        predicate: Predicate<TodoItem>? = nil,
        sortBy: [SortDescriptor<TodoItem>] = []
    ) async throws -> [TodoItem] {
        try await syncWithServer()
        return try fetchLocally(predicate: predicate, sortBy: sortBy)
    }

    func fetchLocally(
        predicate: Predicate<TodoItem>? = nil,
        sortBy: [SortDescriptor<TodoItem>] = []
    ) throws -> [TodoItem] {
        try persistentStorage.fetch(predicate: predicate, sortBy: sortBy)
    }

    func fetchCountLocally(predicate: Predicate<TodoItem>? = nil) throws -> Int {
        try persistentStorage.fetchCount(predicate: predicate)
    }

    func addTodoItem(_ todoItem: TodoItem) async throws {
        try await executeBlockAndSyncOnError { [weak self] in
            self?.persistentStorage.insert(todoItem)
            try await self?.todoNetworkService.addTodoItem(todoItem)
        }
    }

    func toggleDone(_ todoItem: TodoItem) async throws {
        try await executeBlockAndSyncOnError { [weak self] in
            todoItem.isDone.toggle()
            todoItem.modifiedAt = .now
            try await self?.todoNetworkService.editTodoItem(todoItem)
        }
    }

    func toggleDone(_ isDone: Bool, todoItem: TodoItem) async throws {
        try await executeBlockAndSyncOnError { [weak self] in
            todoItem.isDone = isDone
            todoItem.modifiedAt = .now
            try await self?.todoNetworkService.editTodoItem(todoItem)
        }
    }

    func editTodoItem(_ todoItem: TodoItem) async throws {
        try await executeBlockAndSyncOnError { [weak self] in
            try await self?.todoNetworkService.editTodoItem(todoItem)
            self?.persistentStorage.update(persistentModelID: todoItem.persistentModelID, newItem: todoItem)
        }
    }

    func deleteTodoItem(_ todoItem: TodoItem) async throws {
        try await executeBlockAndSyncOnError { [weak self] in
            let id = todoItem.id
            self?.persistentStorage.delete(todoItem)
            try await self?.todoNetworkService.deleteTodoItem(id: id)
        }
    }

    func executeBlockAndSyncOnError(_ block: @escaping () async throws -> Void) async rethrows {
        do {
            try await block()
        } catch {
            try await syncWithServer()
        }
    }

    // MARK: - Private methods
    private func saveTodoItemsToPersistentStorage(localItems: [TodoItem], serverItems: [TodoItem]) {
        for serverItem in serverItems {
            let localItem = localItems.first(where: { $0.id == serverItem.id })
            if let localItem {
                persistentStorage.update(
                    persistentModelID: localItem.persistentModelID,
                    newItem: serverItem
                )
            } else {
                persistentStorage.insert(serverItem)
            }
        }
    }

    private func fetchTodoListFromPersistentStorage() throws -> [TodoItem] {
        return try persistentStorage.fetch(predicate: nil)
    }

    private func deleteLocalItemsNotInServerList(localItems: [TodoItem], serverItems: [TodoItem]) {
        let serverItemIds = Set(serverItems.map { $0.id })
        for localItem in localItems where !serverItemIds.contains(localItem.id) {
            persistentStorage.delete(localItem)
        }
    }

    private func setupBindings() {
        todoNetworkService.$activeRequestsCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                self?.activeRequestsCount = newValue
            }
            .store(in: &cancellables)
    }

}
