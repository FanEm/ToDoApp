//
//  TodoItem.swift
//  ToDo
//
//  Created by Artem Novikov on 15.06.2024.
//

import SwiftUI
import SwiftData
import FileCache

// MARK: - TodoItem
@Model
final class TodoItem: StringIdentifiable, @unchecked Sendable {

    @Attribute(.unique) let id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    var createdAt: Date
    var modifiedAt: Date?
    var color: String?
    @Relationship var category: Category?

    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .basic,
        deadline: Date? = nil,
        isDone: Bool = false,
        createdAt: Date = .now,
        modifiedAt: Date? = nil,
        color: String? = nil,
        category: Category? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.color = color
        self.category = category
    }

}

// MARK: - Equatable
extension TodoItem: Equatable {

    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.importance == rhs.importance &&
        lhs.deadline == rhs.deadline &&
        lhs.isDone == rhs.isDone &&
        lhs.createdAt == rhs.createdAt &&
        lhs.modifiedAt == rhs.modifiedAt &&
        lhs.category == rhs.category
    }

    static var empty: TodoItem {
        TodoItem(
            id: UUID().uuidString,
            text: "",
            importance: .basic,
            deadline: nil,
            isDone: false,
            createdAt: .now,
            modifiedAt: nil,
            color: nil,
            category: nil
        )
    }

    var toNetworkModel: TodoItemNetworkModel {
        TodoItemNetworkModel(
            id: id,
            text: text,
            importance: importance.rawValue,
            deadline: Int(deadline?.timeIntervalSince1970),
            isDone: isDone,
            color: color,
            createdAt: Int(createdAt.timeIntervalSince1970),
            modifiedAt: Int(modifiedAt?.timeIntervalSince1970) ?? Int(createdAt.timeIntervalSince1970),
            lastUpdatedBy: "user_id" // add userId
        )
    }

}

// MARK: - Importance
enum Importance: String, Codable, CaseIterable, Identifiable, Comparable {
    private static func minimum(_ lhs: Self, _ rhs: Self) -> Self {
        switch (lhs, rhs) {
        case (.low, _), (_, .low): .low
        case (.basic, _), (_, .basic): .basic
        case (.important, _), (_, .important): .important
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs != rhs) && (lhs == Self.minimum(lhs, rhs))
    }

    case low, basic, important

    var id: Self { self }

    var symbol: AnyView {
        switch self {
        case .low: AnyView(Image(.importanceLow))
        case .basic: AnyView(Text("no"))
        case .important: AnyView(Image(.importanceHigh))
        }
    }

}

// MARK: - Keys
extension TodoItem {

    enum Keys: String {
        case id, text, importance, deadline, color, category
        case isDone = "is_done"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

}
