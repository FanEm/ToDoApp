//
//  TodoNetworkService.swift
//  ToDo
//
//  Created by Artem Novikov on 15.07.2024.
//

import Foundation
import SwiftUI

// MARK: - TodoNetworkService
final class TodoNetworkService: @unchecked Sendable {

    // MARK: - Public properties
    static let shared = TodoNetworkService()
    @Published private(set) var activeRequestsCount = 0

    // MARK: - Private properties
    private let networkingService: NetworkingService
    private let lock = NSLock()

    // MARK: - Initializers
    private init() {
        self.networkingService = DefaultNetworkingService()
    }

    // MARK: - Public methods
    func fetchTodoList() async throws -> TodoItemListResponseModel {
        try await self.send(request: GetTodoItemListRequest(), type: TodoItemListResponseModel.self)
    }

    func patchTodoList(_ todoItems: [TodoItem]) async throws -> TodoItemListResponseModel {
        try await self.send(
            request: PatchTodoItemListRequest(
                dto: TodoItemListRequestModel(list: todoItems.map { $0.toNetworkModel })
            ),
            type: TodoItemListResponseModel.self
        )
    }

    func getTodoItem(id: String) async throws -> TodoItemElementResponseModel {
        try await self.send(request: GetTodoItemRequest(id: id), type: TodoItemElementResponseModel.self)
    }

    @discardableResult
    func addTodoItem(_ todoItem: TodoItem) async throws -> TodoItemElementResponseModel {
        try await self.send(
            request: AddTodoItemRequest(
                dto: TodoItemElementRequestModel(element: todoItem.toNetworkModel)
            ),
            type: TodoItemElementResponseModel.self
        )
    }

    @discardableResult
    func editTodoItem(_ todoItem: TodoItem) async throws -> TodoItemElementResponseModel {
        try await self.send(
            request: EditTodoItemRequest(
                id: todoItem.id,
                dto: TodoItemElementRequestModel(element: todoItem.toNetworkModel)
            ),
            type: TodoItemElementResponseModel.self
        )
    }

    @discardableResult
    func deleteTodoItem(id: String) async throws -> TodoItemElementResponseModel {
        try await self.send(
            request: DeleteTodoItemRequest(id: id),
            type: TodoItemElementResponseModel.self
        )
    }

    // MARK: - Private methods
    private func send<T: Decodable & Sendable>(request: NetworkRequest, type: T.Type) async throws -> T {
        defer {
            lock.withLock {
                activeRequestsCount -= 1
            }
        }
        lock.withLock {
            activeRequestsCount += 1
        }
        return try await networkingService.sendRequestWithRetry(
            request: request,
            type: type,
            maxAttempts: 3,
            minDelay: 2,
            maxDelay: 120,
            factor: 1.5,
            jitter: 0.05
        )
    }

}
