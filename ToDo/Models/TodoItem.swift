//
//  TodoItem.swift
//  ToDo
//
//  Created by Artem Novikov on 15.06.2024.
//

import Foundation

// MARK: - TodoItem
struct TodoItem {

    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isDone: Bool
    let createdAt: Date
    let modifiedAt: Date?

    init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority,
        deadline: Date? = nil,
        isDone: Bool,
        createdAt: Date,
        modifiedAt: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

}

// MARK: - Priority and Keys
extension TodoItem {

    enum Priority: String {
        case low, medium, high
    }

    enum Keys: String {
        case id, text, priority, deadline
        case isDone = "is_done"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
    }

}

// MARK: - Parse JSON
extension TodoItem {

    var json: Any {
        var dict: [String: Any] = [
            Keys.id.rawValue: id,
            Keys.text.rawValue: text,
            Keys.createdAt.rawValue: createdAt.timeIntervalSince1970,
            Keys.isDone.rawValue: isDone
        ]

        if priority != .medium {
            dict[Keys.priority.rawValue] = priority.rawValue
        }

        if let deadline {
            dict[Keys.deadline.rawValue] = deadline.timeIntervalSince1970
        }

        if let modifiedAt {
            dict[Keys.modifiedAt.rawValue] = modifiedAt.timeIntervalSince1970
        }

        return dict
    }

    static func parse(json: Any) -> TodoItem? {
        switch json {
        case let jsonString as String: parse(string: jsonString)
        case let jsonData as Data: parse(data: jsonData)
        case let jsonDict as [String: Any]: parse(dict: jsonDict)
        default: nil
        }
    }

    // MARK: - Private methods
    private static func parse(string: String) -> TodoItem? {
        guard let data = string.data(using: .utf8) else { return nil }
        return parse(data: data)
    }

    private static func parse(data: Data) -> TodoItem? {
        guard let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return nil }
        return parse(dict: dict)
    }

    private static func parse(dict: [String: Any]) -> TodoItem? {
        guard
           let id = dict[Keys.id.rawValue] as? String,
           let text = dict[Keys.text.rawValue] as? String,
           let createdAtTimeInterval = dict[Keys.createdAt.rawValue] as? TimeInterval,
           let isDone = dict[Keys.isDone.rawValue] as? Bool
        else { return nil }

        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)

        let priorityString = dict[Keys.priority.rawValue] as? String ?? ""
        let priority = Priority(rawValue: priorityString) ?? .medium

        let deadlineTimeInterval = dict[Keys.deadline.rawValue] as? TimeInterval
        let deadline = deadlineTimeInterval.flatMap { Date(timeIntervalSince1970: $0) }

        let modifiedAtTimeInterval = dict[Keys.modifiedAt.rawValue] as? TimeInterval
        let modifiedAt = modifiedAtTimeInterval.flatMap { Date(timeIntervalSince1970: $0) }

        return TodoItem(
           id: id,
           text: text,
           priority: priority,
           deadline: deadline,
           isDone: isDone,
           createdAt: createdAt,
           modifiedAt: modifiedAt
        )
    }

}

// MARK: - Parse CSV
extension TodoItem {

    var csv: String {
        "\(id),\(text),\(priority == .medium ? " " : priority.rawValue)," +
        "\(deadline == nil ? " " : String(deadline!.timeIntervalSince1970))," +
        "\(String(isDone)),\(String(createdAt.timeIntervalSince1970))," +
        "\(modifiedAt == nil ? " " : String(modifiedAt!.timeIntervalSince1970))"
    }

    static var csvHeader: [String] {
        [
            Keys.id.rawValue, Keys.text.rawValue, Keys.priority.rawValue,
            Keys.deadline.rawValue, Keys.isDone.rawValue,
            Keys.createdAt.rawValue, Keys.modifiedAt.rawValue
        ]
    }

    static func parse(csv: String) -> TodoItem? {
        let row = csv.split(separator: ",").map { String($0) }

        var dict = [String: String]()
        for (index, value) in row.enumerated() {
            dict[csvHeader[index]] = value
        }

        guard let id = dict[Keys.id.rawValue],
              let text = dict[Keys.text.rawValue],
              let isDoneString = dict[Keys.isDone.rawValue],
              let isDone = Bool(isDoneString),
              let createdAtString = dict[Keys.createdAt.rawValue],
              let createdAtTimeInterval = TimeInterval(createdAtString)
        else {
            return nil
        }

        let createdAt = Date(timeIntervalSince1970: createdAtTimeInterval)
        let priority = Priority(rawValue: dict[Keys.priority.rawValue] ?? "") ?? .medium
        let deadline = TimeInterval(dict[Keys.deadline.rawValue] ?? "").flatMap { Date(timeIntervalSince1970: $0) }
        let modifiedAt = TimeInterval(dict[Keys.modifiedAt.rawValue] ?? "").flatMap { Date(timeIntervalSince1970: $0) }

        return TodoItem(
            id: id,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            createdAt: createdAt,
            modifiedAt: modifiedAt
        )
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
        lhs.modifiedAt == rhs.modifiedAt
    }

}
