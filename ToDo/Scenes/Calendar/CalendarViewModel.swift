//
//  CalendarViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import Foundation
import Combine
import SwiftData

// MARK: - CalendarViewModel
@MainActor
final class CalendarViewModel: ObservableObject {

    @Published var data: [(date: Date, events: [TodoItem])] = []
    private var repository: TodoRepository

    // MARK: - Initializers
    init(modelContext: ModelContext) {
        self.repository = TodoRepository(
            persistentStorage: PersistentStorage(modelContext: modelContext)
        )
    }

    // MARK: - Public methods
    func fetch() {
        do {
            let items = try repository.fetchLocally()
            updateData(items: items)
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    func toggleDone(_ isDone: Bool, at indexPath: IndexPath) {
        Task {
            do {
                let todoItem = data[indexPath.section].events[indexPath.row]
                try await repository.toggleDone(isDone, todoItem: todoItem)
            }
        }
    }

    // MARK: - Private methods
    private func updateData(items: [TodoItem]) {
        var eventsByDate: [Date: [TodoItem]] = [:]
        items.forEach { eventsByDate[$0.deadline ?? .distantFuture, default: []].append($0)}
        data = eventsByDate
            .map { (date: $0, events: $1.sorted { $0.createdAt < $1.createdAt }) }
            .sorted { $0.date < $1.date }
    }

}
