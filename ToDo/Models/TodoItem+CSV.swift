//
//  TodoItem+CSV.swift
//  ToDo
//
//  Created by Artem Novikov on 28.06.2024.
//

import Foundation

// MARK: - Parse CSV
extension TodoItem {

    var csv: String {
        "\(id),\(text),\(priority == .medium ? " " : priority.rawValue)," +
        "\(deadline == nil ? " " : String(deadline!.timeIntervalSince1970))," +
        "\(String(isDone)),\(String(createdAt.timeIntervalSince1970))," +
        "\(modifiedAt == nil ? " " : String(modifiedAt!.timeIntervalSince1970))," +
        "\(color)"
    }

    static var csvHeader: [String] {
        [
            Keys.id.rawValue, Keys.text.rawValue, Keys.priority.rawValue,
            Keys.deadline.rawValue, Keys.isDone.rawValue,
            Keys.createdAt.rawValue, Keys.modifiedAt.rawValue, Keys.color.rawValue
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
              let createdAtTimeInterval = TimeInterval(createdAtString),
              let color = dict[Keys.color.rawValue]
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
            modifiedAt: modifiedAt,
            color: color
        )
    }

}
