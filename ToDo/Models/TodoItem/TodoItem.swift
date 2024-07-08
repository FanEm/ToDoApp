//
//  TodoItem.swift
//  ToDo
//
//  Created by Artem Novikov on 15.06.2024.
//

import SwiftUI
import FileCache

// MARK: - TodoItem
struct TodoItem: StringIdentifiable {

    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let modifiedAt: Date?
    let color: String?
    let categoryId: String?

    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority = .medium,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdAt: Date = .now,
        modifiedAt: Date? = nil,
        color: String? = nil,
        categoryId: String? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.color = color
        self.categoryId = categoryId
    }

    func copyWith(
        text: String? = nil,
        priority: Priority? = nil,
        deadline: Date?,
        isDone: Bool? = nil,
        modifiedAt: Date? = nil,
        color: String? = nil,
        categoryId: String? = nil
    ) -> TodoItem {
        TodoItem(
            id: self.id,
            text: text ?? self.text,
            priority: priority ?? self.priority,
            deadline: deadline,
            isDone: isDone ?? self.isDone,
            createdAt: self.createdAt,
            modifiedAt: modifiedAt ?? self.modifiedAt,
            color: color,
            categoryId: categoryId
        )
    }

    func toggleDone(_ isDone: Bool) -> TodoItem {
        TodoItem(
            id: self.id,
            text: self.text,
            priority: self.priority,
            deadline: self.deadline,
            isDone: isDone,
            createdAt: self.createdAt,
            modifiedAt: self.modifiedAt,
            color: self.color,
            categoryId: self.categoryId
        )
    }

}

// MARK: - Priority and Keys
extension TodoItem {

    enum Priority: String, CaseIterable, Identifiable, Comparable {
        private static func minimum(_ lhs: Self, _ rhs: Self) -> Self {
            switch (lhs, rhs) {
            case (.low, _), (_, .low): .low
            case (.medium, _), (_, .medium): .medium
            case (.high, _), (_, .high): .high
            }
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            (lhs != rhs) && (lhs == Self.minimum(lhs, rhs))
        }

        case low, medium, high

        var id: Self { self }

        var symbol: AnyView {
            switch self {
            case .low: AnyView(Image(.priorityLow))
            case .medium: AnyView(Text("no"))
            case .high: AnyView(Image(.priorityHigh))
            }
        }

    }

    enum Keys: String {
        case id, text, priority, deadline, color
        case categoryId = "category_id"
        case isDone = "is_done"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

}

// MARK: - Equatable
extension TodoItem: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.priority == rhs.priority &&
        lhs.deadline == rhs.deadline &&
        lhs.isDone == rhs.isDone &&
        lhs.createdAt == rhs.createdAt &&
        lhs.modifiedAt == rhs.modifiedAt &&
        lhs.categoryId == rhs.categoryId
    }

}

extension TodoItem {

    static var empty: TodoItem {
        TodoItem(
            id: UUID().uuidString,
            text: "",
            priority: .medium,
            deadline: nil,
            isDone: false,
            createdAt: .now,
            modifiedAt: nil,
            color: nil,
            categoryId: nil
        )
    }

}
