//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import SwiftUI

// MARK: - TodoViewModel
final class TodoViewModel: ObservableObject {

    @Published var text: String
    @Published var priority: TodoItem.Priority
    @Published var deadline: Date?
    @Published var modifiedAt: Date?
    @Published var color: Color

    @Published var isAlertShown = false
    @Published var isColorPickerShown = false
    
    @Published var selectedDeadline: Date = .nextDay {
        didSet {
            deadline = isDeadlineEnabled ? selectedDeadline : nil
        }
    }
    @Published var isDeadlineEnabled: Bool {
        didSet {
            selectedDeadline = isDeadlineEnabled ? (todoItem.deadline ?? .nextDay) : .nextDay
            deadline = isDeadlineEnabled ? selectedDeadline : nil
        }
    }

    var canItemBeSaved: Bool {
        text != "" &&
        (
            text != todoItem.text ||
            priority != todoItem.priority ||
            deadline != todoItem.deadline ||
            color.hex! != todoItem.color
        )
    }

    var isItemNew: Bool {
        fileCache.items[todoItem.id] == nil
    }

    private let todoItem: TodoItem
    private let fileCache: FileCache

    init(todoItem: TodoItem, fileCache: FileCache = FileCache.shared) {
        self.todoItem = todoItem
        self.fileCache = fileCache
        self.text = todoItem.text
        self.priority = todoItem.priority
        self.deadline = todoItem.deadline
        self.modifiedAt = todoItem.modifiedAt
        self.isDeadlineEnabled = todoItem.deadline != nil
        self.selectedDeadline = todoItem.deadline ?? .nextDay
        self.color = Color(hex: todoItem.color)
    }

    func saveItem() {
        fileCache.addItemAndSaveJson(
            todoItem.copyWith(
                text: text,
                priority: priority,
                deadline: deadline,
                modifiedAt: modifiedAt,
                color: color.hex
            )
        )
    }

    func removeItem() {
        fileCache.removeItemAndSaveJson(id: todoItem.id)
    }

}
