//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import SwiftUI
import SwiftData

// MARK: - TodoViewModel
@MainActor
final class TodoViewModel: ObservableObject {

    // MARK: - Public properties
    @Published var text: String
    @Published var importance: Importance {
        didSet {
            AnalyticsService.todoViewImportance(importance.rawValue)
        }
    }
    @Published var category: Category? {
        didSet {
            color = getColorFromCategory()
        }
    }
    @Published var deadline: Date?
    @Published var modifiedAt: Date?
    @Published var color: Color?

    @Published var isAlertShown = false
    @Published var isColorPickerShown = false
    @Published var isCategoryViewShown = false

    @Published var selectedDeadline: Date = .nextDay {
        didSet {
            deadline = isDeadlineEnabled ? selectedDeadline.stripTime() : nil
            AnalyticsService.todoViewDeadline(enabled: isDeadlineEnabled, date: deadline)
        }
    }
    @Published var isDeadlineEnabled: Bool {
        didSet {
            selectedDeadline = isDeadlineEnabled ? (todoItem.deadline ?? .nextDay) : .nextDay
            deadline = isDeadlineEnabled ? selectedDeadline.stripTime() : nil
            AnalyticsService.todoViewDeadline(enabled: isDeadlineEnabled, date: deadline)
        }
    }

    var canItemBeSaved: Bool {
        text != "" &&
        (
            text != todoItem.text ||
            importance != todoItem.importance ||
            deadline != todoItem.deadline ||
            category != todoItem.category
        )
    }

    var isItemNew: Bool {
        repository.todoItemExists(id: todoItem.id)
    }

    let todoItem: TodoItem

    // MARK: - Private properties
    private var repository: TodoRepository
    private let categoryDataHandler: DataHandler<Category>

    // MARK: - Initializers
    init(
        todoItem: TodoItem,
        repository: TodoRepository = TodoRepository(),
        dataProvider: DataProvider = DataProvider.shared
    ) {
        self.repository = repository
        self.categoryDataHandler = dataProvider.categoryDataHandler
        self.todoItem = todoItem
        self.text = todoItem.text
        self.importance = todoItem.importance
        self.deadline = todoItem.deadline
        self.modifiedAt = todoItem.modifiedAt
        self.isDeadlineEnabled = todoItem.deadline != nil
        self.selectedDeadline = todoItem.deadline ?? .nextDay
        self.category = todoItem.category
        if let hex = category?.color {
            self.color = Color(hex: hex)
        }
    }

    // MARK: - Public methods
    func saveItem() async {
        let itemNew = isItemNew
        todoItem.text = text
        todoItem.importance = importance
        todoItem.deadline = deadline
        todoItem.category = category
        todoItem.modifiedAt = .now
        todoItem.color = color?.hex
        do {
            if itemNew {
                try await repository.addTodoItem(todoItem)
            } else {
                try await repository.editTodoItem(todoItem)
            }
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    func removeItem() async {
        do {
            try await repository.deleteTodoItem(todoItem)
        } catch {
            Logger.error("\(error.localizedDescription)")
        }
    }

    // MARK: - Private methods
    private func getColorFromCategory() -> Color? {
        guard let hex = category?.color else { return nil }
        return Color(hex: hex)
    }

}
