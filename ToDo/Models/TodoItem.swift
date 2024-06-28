//
//  TodoItem.swift
//  ToDo
//
//  Created by Artem Novikov on 15.06.2024.
//

import SwiftUI

// MARK: - TodoItem
struct TodoItem: Identifiable {

    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let modifiedAt: Date?
    let color: String

    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority = .medium,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdAt: Date = .now,
        modifiedAt: Date? = nil,
        color: String = "#fefefeff"
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.color = color
    }

    func copyWith(
        text: String? = nil,
        priority: Priority? = nil,
        deadline: Date?,
        isDone: Bool? = nil,
        modifiedAt: Date? = nil,
        color: String? = nil
    ) -> TodoItem {
        TodoItem(
            id: self.id,
            text: text ?? self.text,
            priority: priority ?? self.priority,
            deadline: deadline,
            isDone: isDone ?? self.isDone,
            createdAt: self.createdAt,
            modifiedAt: modifiedAt ?? self.modifiedAt,
            color: color ?? self.color
        )
    }

}

// MARK: - Priority and Keys
extension TodoItem {

    enum Priority: String, CaseIterable, Identifiable, Comparable {
        private static func minimum(_ lhs: Self, _ rhs: Self) -> Self {
            switch (lhs, rhs) {
            case (.low, _), (_, .low):
                return .low
            case (.medium, _), (_, .medium):
                return .medium
            case (.high, _), (_, .high):
                return .high
            }
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            return (lhs != rhs) && (lhs == Self.minimum(lhs, rhs))
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
        lhs.color == rhs.color
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
            color: "#fefefeff"
        )
    }

}
