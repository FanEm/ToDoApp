//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import SwiftUI
import Combine

// MARK: - TodoViewModel
final class TodoViewModel: ObservableObject {

    @Published var text: String
    @Published var priority: TodoItem.Priority {
        didSet {
            AnalyticsService.todoViewPriority(priority.rawValue)
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
            priority != todoItem.priority ||
            deadline != todoItem.deadline ||
            category?.id != todoItem.categoryId
        )
    }

    var isItemNew: Bool {
        todoItemCache.items[todoItem.id] == nil
    }

    let todoItem: TodoItem
    private let todoItemCache: TodoItemCache
    private let categoryCache: CategoryCache

    private var cancellables = Set<AnyCancellable>()

    init(
        todoItem: TodoItem,
        todoItemCache: TodoItemCache = TodoItemCache.shared,
        categoryCache: CategoryCache = CategoryCache.shared
    ) {
        self.todoItem = todoItem
        self.todoItemCache = todoItemCache
        self.categoryCache = categoryCache
        self.text = todoItem.text
        self.priority = todoItem.priority
        self.deadline = todoItem.deadline
        self.modifiedAt = todoItem.modifiedAt
        self.isDeadlineEnabled = todoItem.deadline != nil
        self.selectedDeadline = todoItem.deadline ?? .nextDay
        if let categoryId = todoItem.categoryId {
            category = categoryCache.items[categoryId]
            if let hex = category?.color {
                self.color = Color(hex: hex)
            }
        }
    }

    func saveItem() {
        todoItemCache.addItemAndSaveJson(
            todoItem.copyWith(
                text: text,
                priority: priority,
                deadline: deadline,
                modifiedAt: modifiedAt,
                color: category?.color,
                categoryId: category?.id
            )
        )
    }

    func removeItem() {
        todoItemCache.removeItemAndSaveJson(id: todoItem.id)
    }

    private func getColorFromCategory() -> Color? {
        guard let hex = category?.color else { return nil }
        return Color(hex: hex)
    }

}
