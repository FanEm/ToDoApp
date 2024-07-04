//
//  CalendarViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 01.07.2024.
//

import Foundation
import Combine

// MARK: - CalendarViewModel
final class CalendarViewModel: ObservableObject {

    @Published var data: [(date: Date, events: [TodoItem])] = []

    private var cancellables = Set<AnyCancellable>()
    private let todoItemCache: TodoItemCache

    init(todoItemCache: TodoItemCache = TodoItemCache.shared) {
        self.todoItemCache = todoItemCache
        setupBindings()
    }

    func toggleDone(_ isDone: Bool, at indexPath: IndexPath) {
        let todoItem = data[indexPath.section].events[indexPath.row]
        todoItemCache.addItemAndSaveJson(todoItem.toggleDone(isDone))
    }

    func toggleDone(_ isDone: Bool, at indexPath: IndexPath, withDelay delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.toggleDone(isDone, at: indexPath)
        }
    }

    private func setupBindings() {
        todoItemCache.$items
            .sink { [weak self] newItems in
                var eventsByDate: [Date: [TodoItem]] = [:]
                newItems.values.forEach {
                    eventsByDate[$0.deadline ?? .distantFuture, default: []].append($0)
                }
                self?.data = eventsByDate
                    .map { (date: $0, events: $1) }
                    .sorted { $0.date < $1.date }
            }
            .store(in: &cancellables)
    }

}
