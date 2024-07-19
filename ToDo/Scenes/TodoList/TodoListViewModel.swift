//
//  TodoListViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 27.06.2024.
//

import SwiftUI
import Combine
import SwiftData

// MARK: - TodoListViewModel
@MainActor
final class TodoListViewModel: ObservableObject {

    // MARK: - Public properties
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
            fetchLocally()
        }
    }
    @Published var sortType: SortType = .addition {
        didSet {
            fetchLocally()
        }
    }
    @Published var doneCount: Int = 0
    @Published private(set) var isLoading = false

    var todoItemToOpen: TodoItem {
        if let selectedTodoItem {
            return selectedTodoItem
        }
        return TodoItem.empty
    }

    // MARK: - Private properties
    @ObservedObject private var repository: TodoRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers
    init(modelContext: ModelContext) {
        self.repository = TodoRepository(
            persistentStorage: PersistentStorage(modelContext: modelContext)
        )
        setupBindings()
    }

    // MARK: - Public methods
    func fetch() async {
        do {
            let items = try await repository.fetchTodoList(
                predicate: #Predicate {
                    showCompleted ? true : !$0.isDone
                }
            )
            try updateDoneCount()
            // SortDescriptor can't sort by comparable enum (
            // https://forums.developer.apple.com/forums/thread/738145
            todoItems = applyFilters(items: items)
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    func fetchLocally() {
        do {
            let items = try repository.fetchLocally(
                predicate: #Predicate {
                    showCompleted ? true : !$0.isDone
                }
            )
            try updateDoneCount()
            todoItems = applyFilters(items: items)
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    func addItem(_ item: TodoItem) async {
        do {
            try await repository.addTodoItem(item)
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    func toggleDone(_ todoItem: TodoItem) async {
        do {
            try await repository.toggleDone(todoItem)
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    func delete(_ todoItem: TodoItem) async {
        do {
            try await repository.deleteTodoItem(todoItem)
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    func toggleShowCompleted() {
        showCompleted.toggle()
    }

    func toggleSortType() {
        sortType = sortType == .addition ? .importance : .addition
    }

    func colorFor(todoItem: TodoItem) -> Color? {
        guard let hex = todoItem.color else { return nil }
        return Color(hex: hex)
    }

    // MARK: - Private methods
    private func applyFilters(items: [TodoItem]) -> [TodoItem] {
        switch sortType {
        case .importance:
            items.sorted {
                if $0.importance == $1.importance {
                    return $0.createdAt < $1.createdAt
                } else {
                    return $0.importance > $1.importance
                }
            }
        case .addition:
            items.sorted { $0.createdAt < $1.createdAt }
        }
    }

    private func updateDoneCount() throws {
        doneCount = try repository.fetchCountLocally(predicate: #Predicate { $0.isDone })
    }

    private func setupBindings() {
        repository.$activeRequestsCount
            .sink { [weak self] newValue in
                self?.isLoading = newValue > 0
            }
            .store(in: &cancellables)
    }

}

extension TodoListViewModel {

    enum SortType {
        case importance, addition
        var descriptionOfNext: String {
            switch self {
            case .importance: String(localized: "sort.byAddition")
            case .addition: String(localized: "sort.byImportance")
            }
        }
    }

}
