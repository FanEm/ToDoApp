//
//  TodoListViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI
import Combine

final class TodoListViewModel: ObservableObject {

    @Published var todoItems: [TodoItem] = []
    @Published var todoViewPresented: Bool = false {
        didSet {
            if !todoViewPresented {
                selectedTodoItem = nil
            }
        }
    }
    @Published var calendarViewPresented: Bool = false
    @Published var selectedTodoItem: TodoItem?
    @Published var newTodo: String = ""
    @Published var showCompleted: Bool = true {
        didSet {
            updateTodoItemsList()
        }
    }
    @Published var sortType: SortType = .addition {
        didSet {
            updateTodoItemsList()
        }
    }
    @Published private var todoItemCache: TodoItemCache

    enum SortType {
        case priority, addition
        var descriptionOfNext: String {
            switch self {
            case .priority: String(localized: "sort.byAddition")
            case .addition: String(localized: "sort.byPriority")
            }
        }
    }

    var todoItemToOpen: TodoItem {
        if let selectedTodoItem {
            return selectedTodoItem
        }
        return TodoItem.empty
    }

    var doneCount: Int {
        todoItemCache.items.values.filter({ $0.isDone }).count
    }

    private var cancellables = Set<AnyCancellable>()

    init(todoItemCache: TodoItemCache = TodoItemCache.shared) {
        self.todoItemCache = todoItemCache
        try? self.todoItemCache.loadJson()
        setupBindings()
    }

    func addItem(_ item: TodoItem) {
        todoItemCache.addItemAndSaveJson(item)
    }

    func toggleDone(_ todoItem: TodoItem) {
        todoItemCache.addItemAndSaveJson(todoItem.toggleDone(!todoItem.isDone))
    }

    func delete(_ todoItem: TodoItem) {
        todoItemCache.removeItemAndSaveJson(id: todoItem.id)
    }

    func toggleShowCompleted() {
        showCompleted.toggle()
    }

    func toggleSortByPriority() {
        sortType = sortType == .addition ? .priority : .addition
    }

    func colorFor(todoItem: TodoItem) -> Color? {
        guard let hex = todoItem.color else { return nil }
        return Color(hex: hex)
    }

    private func updateTodoItemsList() {
        todoItems = applyFilters(items: Array(todoItemCache.items.values))
    }

    private func setupBindings() {
        todoItemCache.$items
            .sink { [weak self] newItems in
                guard let self else { return }
                self.todoItems = self.applyFilters(items: Array(newItems.values))
            }
            .store(in: &cancellables)
    }

    private func applyFilters(items: [TodoItem]) -> [TodoItem] {
        var result = switch sortType {
        case .priority:
            items.sorted {
                if $0.priority == $1.priority {
                    return $0.createdAt < $1.createdAt
                } else {
                    return $0.priority > $1.priority
                }
            }
        case .addition:
            items.sorted { $0.createdAt < $1.createdAt }
        }
        if !showCompleted {
            result = result.filter { !$0.isDone }
        }
        return result
    }

}
