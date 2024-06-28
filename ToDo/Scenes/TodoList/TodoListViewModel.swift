//
//  TodoListViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI
import Combine

final class TodoListViewModel: ObservableObject {

    @Published var todoViewPresented: Bool = false {
        didSet {
            if !todoViewPresented {
                selectedTodoItem = nil
            }
        }
    }
    @Published var selectedTodoItem: TodoItem?
    @Published var newTodo: String = ""
    @Published var fileCache: FileCache
    
    @Published var showCompleted: Bool = true
    @Published var sortType: SortType = .addition

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
        fileCache.items.values.filter({ $0.isDone }).count
    }

    var items: [TodoItem] {
        applyFilters(items: Array(fileCache.items.values))
    }

    private var anyCancellable: AnyCancellable? = nil

    init(fileCache: FileCache = FileCache.shared) {
        self.fileCache = fileCache
        try? self.fileCache.loadJson()
        anyCancellable = fileCache.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

    func addItem(_ item: TodoItem) {
        fileCache.addItemAndSaveJson(item)
    }

    func toggleDone(_ todoItem: TodoItem) {
        fileCache.addItemAndSaveJson(
            todoItem.copyWith(deadline: todoItem.deadline, isDone: !todoItem.isDone)
        )
    }

    func delete(_ todoItem: TodoItem) {
        fileCache.removeItemAndSaveJson(id: todoItem.id)
    }

    func toggleShowCompleted() {
        showCompleted.toggle()
    }

    func toggleSortByPriority() {
        sortType = sortType == .addition ? .priority : .addition
    }

    private func applyFilters(items: [TodoItem]) -> [TodoItem] {
        var result = switch sortType {
        case .priority:
            items.sorted { $0.priority > $1.priority}
        case .addition:
            items.sorted { $0.createdAt < $1.createdAt}
        }
        if !showCompleted {
            result = result.filter { !$0.isDone }
        }
        return result
    }

}
